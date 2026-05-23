import { Controller, Get } from '@nestjs/common';
import { DataSource } from 'typeorm';

/**
 * Generic Health Controller
 * Safe to add to any service without modifying existing code
 * Just add to imports in app.module.ts
 */
@Controller('health')
export class HealthController {
  constructor(private dataSource: DataSource) {}

  @Get()
  async healthCheck() {
    const checks = {
      status: 'checking',
      service: false,
      database: false,
      schema: false,
    };

    checks.service = true;

    try {
      const queryRunner = this.dataSource.createQueryRunner();
      await queryRunner.query('SELECT 1');
      checks.database = true;

      // Basic schema check
      const tables = await queryRunner.getTables();
      checks.schema = tables.length > 0;

      await queryRunner.release();

      const allHealthy =
        checks.service && checks.database && checks.schema;

      return {
        status: allHealthy ? 'UP' : 'DEGRADED',
        timestamp: new Date().toISOString(),
        checks,
      };
    } catch (error) {
      return {
        status: 'DOWN',
        timestamp: new Date().toISOString(),
        checks,
        error: error.message,
      };
    }
  }

  @Get('ready')
  async readinessProbe() {
    try {
      const queryRunner = this.dataSource.createQueryRunner();
      await queryRunner.query('SELECT 1');
      await queryRunner.release();
      return { status: 'READY' };
    } catch (error) {
      return { status: 'NOT_READY', error: error.message };
    }
  }
}
