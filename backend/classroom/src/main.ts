import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Swagger config
  const config = new DocumentBuilder()
    .setTitle('Education Platform Gateway')
    .setDescription('Gateway API for the Education platform')
    .setVersion('1.0')
    .addTag('gateway')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  app.enableCors();

  // Gateway écoute sur 3000
  await app.listen(3004, '0.0.0.0');

  console.log(`Classroom Service is running at http://localhost:3004`);
  console.log(`Swagger is available at http://localhost:3004/api`);
}
bootstrap();
