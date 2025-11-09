import { Injectable } from '@nestjs/common';

@Injectable()
export class UsersService {
  private users = [
    { id: '1', username: 'admin', email: 'admin@example.com', role: 'admin' },
  ];

  create(createUserDto: any) {
    const user = { id: Date.now().toString(), ...createUserDto };
    this.users.push(user);
    return user;
  }

  findAll() {
    return this.users;
  }

  findOne(id: string) {
    return this.users.find(u => u.id === id);
  }

  findByUsername(username: string) {
    return this.users.find(u => u.username === username);
  }

  update(id: string, updateUserDto: any) {
    const index = this.users.findIndex(u => u.id === id);
    if (index > -1) {
      this.users[index] = { ...this.users[index], ...updateUserDto };
      return this.users[index];
    }
    return null;
  }

  remove(id: string) {
    const index = this.users.findIndex(u => u.id === id);
    if (index > -1) {
      this.users.splice(index, 1);
      return { deleted: true };
    }
    return { deleted: false };
  }
}
