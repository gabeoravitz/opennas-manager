import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '@store/authStore';

export default function LoginPage() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();
  const login = useAuthStore(state => state.login);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    try {
      if (username === 'admin' && password === 'admin123') {
        login(
          { id: '1', username, email: 'admin@example.com', role: 'admin' },
          'mock_token'
        );
        navigate('/');
      } else {
        setError('Invalid credentials');
      }
    } catch (err) {
      setError('Login failed');
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-primary-500 to-primary-700">
      <div className="w-full max-w-md">
        <div className="card">
          <div className="card-body space-y-6">
            <div className="text-center">
              <h1 className="text-3xl font-bold text-gray-900">OpenNAS Manager</h1>
              <p className="mt-2 text-sm text-gray-600">Sign in to your account</p>
            </div>

            <form onSubmit={handleSubmit} className="space-y-4">
              {error && (
                <div className="rounded bg-error-50 p-3 text-sm text-error-700">
                  {error}
                </div>
              )}

              <div>
                <label htmlFor="username" className="block text-sm font-medium text-gray-700">
                  Username
                </label>
                <input
                  id="username"
                  name="username"
                  type="text"
                  required
                  className="input mt-1"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                />
              </div>

              <div>
                <label htmlFor="password" className="block text-sm font-medium text-gray-700">
                  Password
                </label>
                <input
                  id="password"
                  name="password"
                  type="password"
                  required
                  className="input mt-1"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                />
              </div>

              <button type="submit" className="btn-primary w-full">
                Sign in
              </button>
            </form>

            <div className="text-center text-xs text-gray-500">
              Default credentials: admin / admin123
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
