import { IsString, IsNumber, IsNotEmpty, IsOptional, IsBoolean, IsISO8601, IsEmail, IsArray } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateStudentDto {
    @IsNotEmpty()
    @IsString()
    firstName: string;

    @IsOptional()
    @IsString()
    numeroInscriptio?: string;

    @IsNotEmpty()
    @IsString()
    lastName: string;

    @IsNotEmpty()
    @IsEmail()
    email: string;

    @IsOptional()
    @IsISO8601()
    @Type(() => Date)
    dateOfBirth?: Date;

    @IsOptional()
    @IsString()
    phoneNumber?: string;

    @IsOptional()
    @IsString()
    address?: string;

    @IsOptional()
    @IsBoolean()
    isActive?: boolean;

    @IsOptional()
    @IsISO8601()
    @Type(() => Date)
    enrollmentDate?: Date;

    @IsOptional()
    @IsString()
    observations?: string;

    @IsOptional()
    @IsArray()
    interventionReports?: Record<string, any>[];

    @IsOptional()
    @IsNumber()
    parentId?: number;

    @IsOptional()
    @IsNumber()
    classroomId?: number;

    @IsNotEmpty()
    @IsString()
    password: string;

    @IsOptional()
    @IsString()
    role?: string;
}
