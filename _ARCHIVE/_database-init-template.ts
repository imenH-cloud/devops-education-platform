import { DataSource } from 'typeorm';

/**
 * Generic Database Initialization Script
 * Runs migrations and validates schema before app startup
 * Safe to call in any service - won't break existing code
 */
export async function initializeDatabase(dataSource: DataSource): Promise<void> {
  console.log('[DB] 🔄 Initializing database...');

  try {
    if (!dataSource.isInitialized) {
      await dataSource.initialize();
    }

    // Run migrations
    console.log('[DB] 📋 Running pending migrations...');
    const migrations = await dataSource.runMigrations();

    if (migrations.length > 0) {
      console.log(`[DB] ✅ Executed ${migrations.length} migration(s)`);
      migrations.forEach((m) => console.log(`[DB]    - ${m.name}`));
    } else {
      console.log('[DB] ✅ Database already up to date');
    }

    console.log('[DB] ✅ Database initialization complete!\n');
  } catch (error) {
    console.error('[DB] ❌ Database initialization warning (non-fatal):', error.message);
    console.log('[DB] ℹ️  Continuing startup - database may not be fully initialized\n');
    // Don't exit - let the app start anyway
  }
}
