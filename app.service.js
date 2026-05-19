"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppService = void 0;
const common_1 = require("@nestjs/common");
const axios_1 = require("@nestjs/axios");
const rxjs_1 = require("rxjs");
let AppService = class AppService {
    httpService;
    constructor(httpService) {
        this.httpService = httpService;
    }
    getHello() {
        return 'Hello World!';
    }
    async getUsers() {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get('http://user-service:3002/user'));
        return response.data;
    }
    async getUserById(id) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get(`http://user-service:3002/user/${id}`));
        return response.data;
    }
    async getUserByEmail(email) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get(`http://user-service:3002/user/email/${email}`));
        return response.data;
    }
    async createUser(createUserDto) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.post('http://user-service:3002/user', createUserDto));
        return response.data;
    }
    async updateUser(id, updateUserDto) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.patch(`http://user-service:3002/user/${id}`, updateUserDto));
        return response.data;
    }
    async deleteUser(id) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.delete(`http://user-service:3002/user/${id}`));
        return response.data;
    }
    async deleteMultipleUsers(ids) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.post('http://user-service:3002/user/deleteMultipleUser', ids));
        return response.data;
    }
    async login(authUserDto) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.post('http://auth-service:3001/auth/login', authUserDto));
        return response.data;
    }
    async getActivities() {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get('http://activity-service:3003/activities'));
        return response.data;
    }
    async getActivityById(id) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get(`http://activity-service:3003/activities/${id}`));
        return response.data;
    }
    async createActivity(createActivityDto) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.post('http://activity-service:3003/activities', createActivityDto));
        return response.data;
    }
    async updateActivity(id, updateActivityDto) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.patch(`http://activity-service:3003/activities/${id}`, updateActivityDto));
        return response.data;
    }
    async completeActivity(id) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.put(`http://activity-service:3003/activities/${id}/complete`, {}));
        return response.data;
    }
    async deleteActivity(id) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.delete(`http://activity-service:3003/activities/${id}`));
        return response.data;
    }
    async getParents() {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get('http://parent-service:3004/parent'));
        return response.data;
    }
    async getParentById(id) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get(`http://parent-service:3004/parent/${id}`));
        return response.data;
    }
    async createParent(createParentDto) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.post('http://parent-service:3004/parent', createParentDto));
        return response.data;
    }
    async updateParent(id, updateParentDto) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.patch(`http://parent-service:3004/parent/${id}`, updateParentDto));
        return response.data;
    }
    async deleteParent(id) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.delete(`http://parent-service:3004/parent/${id}`));
        return response.data;
    }
    async deleteMultipleParents(ids) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.post('http://parent-service:3004/parent/deleteMultiple', ids));
        return response.data;
    }
    async getStudents() {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get('http://student-service:3005/student'));
        return response.data;
    }
    async getStudentById(id) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get(`http://student-service:3005/student/${id}`));
        return response.data;
    }
    async createStudent(createStudentDto) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.post('http://student-service:3005/student', createStudentDto));
        return response.data;
    }
    async updateStudent(id, updateStudentDto) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.put(`http://student-service:3005/student/${id}`, updateStudentDto));
        return response.data;
    }
    async deleteStudent(id) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.delete(`http://student-service:3005/student/${id}`));
        return response.data;
    }
    async getClassrooms() {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get('http://classroom-service:3006/classroom'));
        return response.data;
    }
    async getClassroomById(id) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get(`http://classroom-service:3006/classroom/${id}`));
        return response.data;
    }
    async createClassroom(createClassroomDto) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.post('http://classroom-service:3006/classroom', createClassroomDto));
        return response.data;
    }
    async updateClassroom(id, updateClassroomDto) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.patch(`http://classroom-service:3006/classroom/${id}`, updateClassroomDto));
        return response.data;
    }
    async deleteClassroom(id) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.delete(`http://classroom-service:3006/classroom/${id}`));
        return response.data;
    }
    async getTeachers() {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get('http://teacher-service:3007/teachers?page=1&limit=100'));
        return response.data;
    }
    async getTeacherById(id) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get(`http://teacher-service:3007/teachers/${id}`));
        return response.data;
    }
    async createTeacher(createTeacherDto) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.post('http://teacher-service:3007/teachers', createTeacherDto));
        return response.data;
    }
    async updateTeacher(id, updateTeacherDto) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.patch(`http://teacher-service:3007/teachers/${id}`, updateTeacherDto));
        return response.data;
    }
    async deleteTeacher(id) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.delete(`http://teacher-service:3007/teachers/${id}`));
        return response.data;
    }
    async searchTeachers(query) {
        const response = await (0, rxjs_1.lastValueFrom)(this.httpService.get(`http://teacher-service:3007/teachers/search?query=${query}`));
        return response.data;
    }
};
exports.AppService = AppService;
exports.AppService = AppService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [axios_1.HttpService])
], AppService);
//# sourceMappingURL=app.service.js.map
