import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(private jwtService: JwtService) {}

  async validateUser(username: string, password: string): Promise<any> {
    if (username === 'admin' && password === 'admin123') {
      return { id: '1', username: 'admin', email: 'admin@example.com', role: 'admin' };
    }
    return null;
  }

  async login(user: any) {
    const payload = { username: user.username, sub: user.id, role: user.role };
    return {
      user,
      token: this.jwtService.sign(payload),
    };
  }
}
