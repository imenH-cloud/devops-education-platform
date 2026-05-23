import { Controller, Get } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Controller('health')
export class HealthController {
  constructor(private dataSource: DataSource) {}

  /**
   * Health check - verifies:
   * 1. Service is running
   * 2. Database connection is active
   * 3. Required tables exist
   * 4. Required columns exist
   */
  @Get()
  async healthCheck() {
    const checks = {
      status: 'checking',
      service: false,
      database: false,
      schema: false,
    };

    // Service is running
    checks.service = true;

    try {
      // Check database connection
      const queryRunner = this.dataSource.createQueryRunner();
      await queryRunner.query('SELECT 1');
      await queryRunner.release();
      checks.database = true;

      // Verify schema
      const activityTable = await queryRunner.hasTable('activity');
      const classroomTable = await queryRunner.hasTable('classroom');

      if (activityTable && classroomTable) {
        const activityColumns = await queryRunner.getTableColumns('activity');
        const requiredColumns = [
          'id',
          'name',
          'classroomId',
          'date',
          'duration',
          'isCompleted',
        ];

        const allColumnsExist = requiredColumns.every((colName) =>
          activityColumns.some((col) => col.name === colName),
        );

        checks.schema = allColumnsExist;
      }

      await queryRunner.release();

      const allHealthy =
        checks.service && checks.database && checks.schema;

      return {
        status: allHealthy ? 'UP' : 'DEGRADED',
        timestamp: new Date().toISOString(),
        checks,
        errors:
          allHealthy
            ? []
            : [
                !checks.service && 'Service not responding',
                !checks.database && 'Database connection failed',
                !checks.schema &&
                  'Database schema incomplete - run migrations',
              ].filter(Boolean),
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

  /**
   * Detailed health endpoint for Kubernetes liveness/readiness probes
   */
  @Get('ready')
  async readinessProbe() {
    try {
      const queryRunner = this.dataSource.createQueryRunner();
      await queryRunner.query('SELECT 1');
      await queryRunner.release();

      // Also check if required tables exist
      const activityTable = await queryRunner.hasTable('activity');
      if (!activityTable) {
        return { status: 'NOT_READY', reason: 'Schema not initialized' };
      }

      return { status: 'READY' };
    } catch (error) {
      return { status: 'NOT_READY', error: error.message };
    }
  }
}
