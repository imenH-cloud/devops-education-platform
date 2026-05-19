import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Configuration Swagger spécifique au service Teacher
  const config = new DocumentBuilder()
    .setTitle('Teacher Service')
    .setDescription('API pour la gestion des enseignants')
    .setVersion('1.0')
    .addTag('teachers')
    .build();
  
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);
  
  // Activer CORS
  app.enableCors();

  // Écouter sur le port 3007 (ou via variable d'environnement)
  const port = process.env.PORT || 3007;
  await app.listen(port, '0.0.0.0');

  console.log(`Teacher service is running at http://0.0.0.0:${port}`);
  console.log(`Swagger available at http://0.0.0.0:${port}/api`);
}
bootstrap();