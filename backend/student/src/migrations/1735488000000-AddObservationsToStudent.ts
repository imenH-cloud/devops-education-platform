import { MigrationInterface, QueryRunner, TableColumn } from 'typeorm';

export class AddObservationsToStudent1735488000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    const table = await queryRunner.hasTable('student');
    if (!table) {
      return;
    }

    const observationsColumn = await queryRunner.hasColumn('student', 'observations');
    if (!observationsColumn) {
      await queryRunner.addColumn(
        'student',
        new TableColumn({
          name: 'observations',
          type: 'text',
          isNullable: true,
          default: null,
        }),
      );
    }

    const reportsColumn = await queryRunner.hasColumn('student', 'interventionReports');
    if (!reportsColumn) {
      await queryRunner.addColumn(
        'student',
        new TableColumn({
          name: 'interventionReports',
          type: 'json',
          isNullable: true,
          default: null,
        }),
      );
    }
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    const table = await queryRunner.hasTable('student');
    if (!table) {
      return;
    }

    const observationsColumn = await queryRunner.hasColumn('student', 'observations');
    if (observationsColumn) {
      await queryRunner.dropColumn('student', 'observations');
    }

    const reportsColumn = await queryRunner.hasColumn('student', 'interventionReports');
    if (reportsColumn) {
      await queryRunner.dropColumn('student', 'interventionReports');
    }
  }
}
