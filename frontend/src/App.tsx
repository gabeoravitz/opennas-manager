import { Routes, Route, Navigate } from 'react-router-dom';
import { Toaster } from 'react-hot-toast';
import { useAuthStore } from '@store/authStore';
import LoginPage from '@pages/auth/LoginPage';
import DashboardLayout from '@components/layout/DashboardLayout';
import Dashboard from '@pages/Dashboard';
import FileStation from '@pages/FileStation';
import PackageCenter from '@pages/PackageCenter';
import LogCenter from '@pages/LogCenter';
import TaskScheduler from '@pages/TaskScheduler';
import ResourceMonitor from '@pages/ResourceMonitor';
import StorageManager from '@pages/StorageManager';
import UserManagement from '@pages/UserManagement';
import GroupManagement from '@pages/GroupManagement';
import NetworkSettings from '@pages/NetworkSettings';
import SecuritySettings from '@pages/SecuritySettings';

function App() {
  const { isAuthenticated } = useAuthStore();

  if (!isAuthenticated) {
    return (
      <>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="*" element={<Navigate to="/login" replace />} />
        </Routes>
        <Toaster position="top-right" />
      </>
    );
  }

  return (
    <>
      <Routes>
        <Route path="/" element={<DashboardLayout />}>
          <Route index element={<Dashboard />} />
          <Route path="file-station" element={<FileStation />} />
          <Route path="package-center" element={<PackageCenter />} />
          <Route path="log-center" element={<LogCenter />} />
          <Route path="task-scheduler" element={<TaskScheduler />} />
          <Route path="resource-monitor" element={<ResourceMonitor />} />
          <Route path="storage-manager" element={<StorageManager />} />
          <Route path="users" element={<UserManagement />} />
          <Route path="groups" element={<GroupManagement />} />
          <Route path="network" element={<NetworkSettings />} />
          <Route path="security" element={<SecuritySettings />} />
        </Route>
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
      <Toaster position="top-right" />
    </>
  );
}

export default App;
