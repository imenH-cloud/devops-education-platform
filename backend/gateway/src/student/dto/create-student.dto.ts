export class CreateStudentDto {
    id:number
  firstName: string;
  numeroInscriptio: string;
  lastName: string;
  email: string;
  dateOfBirth: Date;
  phoneNumber: string;
  address: string;
  isActive?: boolean;
  enrollmentDate: Date;
  observations?: string;
  interventionReports?: Record<string, any>[];
}
