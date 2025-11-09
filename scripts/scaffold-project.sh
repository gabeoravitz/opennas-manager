#!/bin/bash

# OpenNAS Manager - Project Scaffolding Script
# This script creates the complete directory structure for the project

set -e

echo "🚀 Scaffolding OpenNAS Manager project structure..."

# Root directories
mkdir -p backend/src/{modules,common,database,migrations,seeds}
mkdir -p frontend/src/{components,pages,features,hooks,services,store,styles,utils,types,test}
mkdir -p e2e/{tests,fixtures,screenshots}
mkdir -p docs
mkdir -p docker
mkdir -p .github/workflows
mkdir -p scripts

# Backend module structure
mkdir -p backend/src/modules/{auth,users,groups,files,storage,packages,logs,tasks,notifications,network,security,directory}
mkdir -p backend/src/modules/auth/{controllers,services,guards,strategies,dto}
mkdir -p backend/src/modules/users/{controllers,services,entities,dto}
mkdir -p backend/src/modules/groups/{controllers,services,entities,dto}
mkdir -p backend/src/modules/files/{controllers,services,entities,dto}
mkdir -p backend/src/modules/storage/{controllers,services,entities,dto}
mkdir -p backend/src/modules/packages/{controllers,services,entities,dto}
mkdir -p backend/src/modules/logs/{controllers,services,entities,dto}
mkdir -p backend/src/modules/tasks/{controllers,services,entities,dto}
mkdir -p backend/src/modules/notifications/{controllers,services,entities,dto}
mkdir -p backend/src/modules/network/{controllers,services,entities,dto}
mkdir -p backend/src/modules/security/{controllers,services,entities,dto}
mkdir -p backend/src/modules/directory/{controllers,services,entities,dto}

# Backend common
mkdir -p backend/src/common/{decorators,filters,interceptors,pipes,guards,middleware}
mkdir -p backend/src/database/{config,migrations,seeds}
mkdir -p backend/test/{unit,integration,e2e}

# Frontend component structure
mkdir -p frontend/src/components/{layout,ui,forms,tables,modals,widgets}
mkdir -p frontend/src/components/layout
mkdir -p frontend/src/components/ui/{Button,Input,Card,Table,Modal,Dropdown,Badge,Spinner,Toast,Sidebar,Topbar}

# Frontend pages
mkdir -p frontend/src/pages/{auth,control-panel,productivity}
mkdir -p frontend/src/pages/auth
mkdir -p frontend/src/pages/control-panel/{network,storage,security,users,system}
mkdir -p frontend/src/pages/productivity/{office,chat,calendar,contacts,mail,notes}

# Frontend features
mkdir -p frontend/src/features/{auth,dashboard,file-station,package-center,log-center,task-scheduler,resource-monitor}

# Frontend services
mkdir -p frontend/src/services/{api,websocket}

# Frontend store
mkdir -p frontend/src/store/{slices,hooks}

# E2E tests
mkdir -p e2e/tests/{auth,dashboard,file-management,control-panel,packages}

# Documentation
mkdir -p docs/{api,components,features,deployment}

# Docker
mkdir -p docker/{frontend,backend,nginx}

echo "✅ Project structure created successfully!"
echo ""
echo "Directory tree:"
tree -L 3 -I 'node_modules' . || echo "Install 'tree' command for better visualization"
