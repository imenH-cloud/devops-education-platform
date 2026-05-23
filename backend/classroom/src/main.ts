import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable global validation
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  // Swagger config
  const config = new DocumentBuilder()
    .setTitle('Classroom Service')
    .setDescription('API pour la gestion des salles de classe')
    .setVersion('1.0')
    .addTag('classrooms')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  app.enableCors();

  await app.listen(3004, '0.0.0.0');

  console.log(`Classroom Service is running at http://localhost:3004`);
  console.log(`Swagger is available at http://localhost:3004/api`);
}
bootstrap();
