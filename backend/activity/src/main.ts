import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const config = new DocumentBuilder()
    .setTitle('Activity Service')
    .setDescription('API pour la gestion des activités')
    .setVersion('1.0')
    .addTag('activities')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  app.enableCors();

  await app.listen(3003, '0.0.0.0');
  console.log('Activity service running on port 3003');
}
bootstrap();