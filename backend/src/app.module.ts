import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { GroupsModule } from './modules/groups/groups.module';
import { FilesModule } from './modules/files/files.module';
import { StorageModule } from './modules/storage/storage.module';
import { PackagesModule } from './modules/packages/packages.module';
import { LogsModule } from './modules/logs/logs.module';
import { TasksModule } from './modules/tasks/tasks.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { NetworkModule } from './modules/network/network.module';
import { SecurityModule } from './modules/security/security.module';
import { DirectoryModule } from './modules/directory/directory.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DATABASE_HOST || 'localhost',
      port: parseInt(process.env.DATABASE_PORT) || 5432,
      username: process.env.DATABASE_USER || 'opennas',
      password: process.env.DATABASE_PASSWORD || 'opennas_dev_password',
      database: process.env.DATABASE_NAME || 'opennas',
      autoLoadEntities: true,
      synchronize: process.env.NODE_ENV === 'development',
    }),
    AuthModule,
    UsersModule,
    GroupsModule,
    FilesModule,
    StorageModule,
    PackagesModule,
    LogsModule,
    TasksModule,
    NotificationsModule,
    NetworkModule,
    SecurityModule,
    DirectoryModule,
  ],
})
export class AppModule {}
