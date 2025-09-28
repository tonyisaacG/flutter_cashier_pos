import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// A singleton class that manages the SQLite database for the application
class DatabaseHelper {
  // Database name and version
  static const String _databaseName = 'cashier_pos.db';
  static const int _databaseVersion = 1;

  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  /// Get the database instance, initialize if not already done
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_databaseName);
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDB(String filePath) async {
    // Make sure the directory exists
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, filePath);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  /// Configure database settings
  Future<void> _onConfigure(Database db) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Create the database tables
  Future<void> _createDB(Database db, int version) async {
    await _createSaleTables(db);
    await _createProductTables(db);
    await _createCategoryTables(db);
    await _createInventoryTables(db);
    await _createPurchaseTables(db);

    // Create indexes for better performance
    await _createIndexes(db);
  }

  /// Create sale-related tables
  Future<void> _createSaleTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sale_invoices (
        id TEXT PRIMARY KEY,
        invoice_number TEXT NOT NULL,
        invoice_date TEXT NOT NULL,
        customer_id TEXT,
        customer_name TEXT,
        customer_phone TEXT,
        subtotal REAL NOT NULL,
        discount REAL NOT NULL,
        tax REAL NOT NULL,
        total REAL NOT NULL,
        paid_amount REAL NOT NULL,
        due_amount REAL NOT NULL,
        status TEXT NOT NULL,
        type TEXT NOT NULL,
        notes TEXT,
        created_by TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        return_ref_id TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS sale_items (
        id TEXT PRIMARY KEY,
        invoice_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        product_code TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        discount REAL NOT NULL,
        tax REAL NOT NULL,
        unit TEXT,
        barcode TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (invoice_id) REFERENCES sale_invoices(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS payments (
        id TEXT PRIMARY KEY,
        invoice_id TEXT NOT NULL,
        amount REAL NOT NULL,
        method TEXT NOT NULL,
        transaction_id TEXT,
        notes TEXT,
        payment_date TEXT NOT NULL,
        received_by TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (invoice_id) REFERENCES sale_invoices(id) ON DELETE CASCADE
      )
    ''');
  }

  /// Create product-related tables
  Future<void> _createProductTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        code TEXT NOT NULL,
        barcode TEXT,
        description TEXT,
        category_id TEXT,
        cost_price REAL NOT NULL,
        selling_price REAL NOT NULL,
        tax_rate REAL NOT NULL,
        discount_rate REAL NOT NULL,
        quantity INTEGER NOT NULL,
        alert_quantity INTEGER,
        unit TEXT,
        image_url TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        FOREIGN KEY (category_id) REFERENCES categories(id)
      )
    ''');
  }

  /// Create category-related tables
  Future<void> _createCategoryTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        parent_id TEXT,
        image_url TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        FOREIGN KEY (parent_id) REFERENCES categories(id)
      )
    ''');
  }

  /// Create inventory-related tables
  Future<void> _createInventoryTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS inventory_movements (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        movement_type TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        reference_id TEXT,
        reference_type TEXT,
        notes TEXT,
        created_by TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS stock_adjustments (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        quantity_before INTEGER NOT NULL,
        quantity_after INTEGER NOT NULL,
        adjustment_type TEXT NOT NULL,
        reason TEXT,
        notes TEXT,
        created_by TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products(id)
      )
    ''');
  }

  /// Create purchase-related tables
  Future<void> _createPurchaseTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS purchase_invoices (
        id TEXT PRIMARY KEY,
        invoice_number TEXT NOT NULL,
        invoice_date TEXT NOT NULL,
        supplier_id TEXT,
        supplier_name TEXT,
        supplier_phone TEXT,
        subtotal REAL NOT NULL,
        discount REAL NOT NULL,
        tax REAL NOT NULL,
        total REAL NOT NULL,
        paid_amount REAL NOT NULL,
        due_amount REAL NOT NULL,
        status TEXT NOT NULL,
        type TEXT NOT NULL,
        notes TEXT,
        created_by TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        return_ref_id TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS purchase_items (
        id TEXT PRIMARY KEY,
        invoice_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        product_code TEXT NOT NULL,
        cost_price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        discount REAL NOT NULL,
        tax REAL NOT NULL,
        unit TEXT,
        barcode TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (invoice_id) REFERENCES purchase_invoices(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS suppliers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        address TEXT,
        tax_number TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS purchase_returns (
        id TEXT PRIMARY KEY,
        return_number TEXT NOT NULL,
        return_date TEXT NOT NULL,
        purchase_invoice_id TEXT NOT NULL,
        supplier_id TEXT,
        supplier_name TEXT,
        total_amount REAL NOT NULL,
        reason TEXT,
        notes TEXT,
        created_by TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (purchase_invoice_id) REFERENCES purchase_invoices(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS purchase_return_items (
        id TEXT PRIMARY KEY,
        return_id TEXT NOT NULL,
        purchase_item_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        total_amount REAL NOT NULL,
        reason TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (return_id) REFERENCES purchase_returns(id) ON DELETE CASCADE
      )
    ''');
  }

  /// Create database indexes for better query performance
  Future<void> _createIndexes(Database db) async {
    // Sale indexes
    await db.execute('CREATE INDEX IF NOT EXISTS idx_sale_invoices_date ON sale_invoices(invoice_date)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_sale_invoices_status ON sale_invoices(status)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_sale_items_invoice ON sale_items(invoice_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_payments_invoice ON payments(invoice_id)');

    // Purchase indexes
    await db.execute('CREATE INDEX IF NOT EXISTS idx_purchase_invoices_date ON purchase_invoices(invoice_date)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_purchase_invoices_status ON purchase_invoices(status)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_purchase_items_invoice ON purchase_items(invoice_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_purchase_returns_purchase_invoice ON purchase_returns(purchase_invoice_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_purchase_return_items_return ON purchase_return_items(return_id)');

    // Product indexes
    await db.execute('CREATE INDEX IF NOT EXISTS idx_products_category ON products(category_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_products_code ON products(code)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_products_barcode ON products(barcode)');

    // Category indexes
    await db.execute('CREATE INDEX IF NOT EXISTS idx_categories_parent ON categories(parent_id)');

    // Inventory indexes
    await db.execute('CREATE INDEX IF NOT EXISTS idx_inventory_product ON inventory_movements(product_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_inventory_reference ON inventory_movements(reference_type, reference_id)');
  }

  /// Close the database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  /// Delete the database file (for development/testing)
  Future<void> deleteDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  /// Get the database file size in MB
  Future<double> getDatabaseSize() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    final file = File(path);

    if (await file.exists()) {
      final sizeInBytes = await file.length();
      return sizeInBytes / (1024 * 1024); // Convert to MB
    }

    return 0.0;
  }

  /// Backup the database to a file
  Future<File> backupDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${documentsDirectory.path}/backups');

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final backupPath = '${backupDir.path}/backup_$timestamp.db';

    final dbPath = join(documentsDirectory.path, _databaseName);
    final dbFile = File(dbPath);

    if (await dbFile.exists()) {
      return await dbFile.copy(backupPath);
    }

    throw Exception('Database file not found');
  }
}
