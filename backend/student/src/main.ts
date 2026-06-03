import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ValidationPipe, BadRequestException } from '@nestjs/common';
import { AllExceptionsFilter } from './common/all-exceptions.filter';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Validation DISABLED for debugging - we have schema mismatch
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: false,
      forbidNonWhitelisted: false,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
      skipMissingProperties: true,
    }),
  );

  // Global exception filter
  app.useGlobalFilters(new AllExceptionsFilter());

  // Swagger config
  const config = new DocumentBuilder()
    .setTitle('Student Service')
    .setDescription('API pour la gestion des étudiants')
    .setVersion('1.0')
    .addTag('students')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  app.enableCors();

  await app.listen(3005, '0.0.0.0');

  console.log(`Student Service is running at http://localhost:3005`);
  console.log(`Swagger is available at http://localhost:3005/api`);
}
bootstrap();
