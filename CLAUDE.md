# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this module.

## Module Overview

The `human_resources-database` module manages database schema and data for the human resources domain of the ERP system. This module handles employee information, organizational structures, HR processes, and compliance data, using Liquibase for schema migrations and Docker for containerization.

## Technology Stack

- **Database**: PostgreSQL
- **Migration Tool**: Liquibase
- **Container**: Docker
- **Package Manager**: npm
- **Testing**: Cucumber.js with BDD approach
- **Test Database**: pg-promise for database connections

## Project Structure

```
human_resources-database/
├── Dockerfile                    # Database container configuration
├── database_change_log.yml       # Liquibase main changelog
├── databasechangelog.csv        # Liquibase execution history
├── package.json                 # Node.js dependencies and scripts
├── package-lock.json            # Exact dependency versions
├── sql/                         # Database initialization scripts
│   ├── 01-install-extensions.sql
│   ├── 02-create-database.sql
│   └── 03-initial-data.sql
└── features/                    # BDD test specifications
    ├── step_definitions/
    │   └── hooks.js
    └── support/
        ├── chai.js
        ├── config.js
        ├── database.js
        └── world.js
```

## Build and Development Commands

### Database Operations
```bash
# Install dependencies
npm install

# Build database schema (offline)
npm run build:database

# Build Docker container
npm run build:docker

# Apply database changes to running database
npm run update_database

# Start database container
npm run start

# Push container to registry
npm run push

# Clean up build artifacts and containers
npm run clean
```

### Testing
```bash
# Run BDD tests for HR database
npm test
```

## Human Resources Domain Features

### Employee Management
- **Employee Records**: Personal and professional information
- **Employee Status**: Active, inactive, terminated employee states
- **Position Management**: Job titles, roles, and organizational positions
- **Department Structure**: Organizational hierarchy and reporting lines

### Compensation and Benefits
- **Salary Information**: Compensation structures and history
- **Benefits Administration**: Health, retirement, and other benefits
- **Performance Reviews**: Employee evaluation and feedback systems
- **Bonus and Incentive Tracking**: Variable compensation management

### Time and Attendance
- **Time Tracking**: Work hours, overtime, and time-off requests
- **Leave Management**: Vacation, sick leave, and other time-off types
- **Scheduling**: Work schedule and shift management
- **Compliance Tracking**: Labor law and regulation compliance

### Recruitment and Onboarding
- **Candidate Management**: Recruitment pipeline and applicant tracking
- **Interview Process**: Interview scheduling and feedback collection
- **Onboarding Workflows**: New employee integration processes
- **Background Checks**: Pre-employment screening and verification

## Development Workflow

### HR Schema Management
1. **HR Business Analysis**: Understand human resources requirements
2. **Compliance Considerations**: Ensure regulatory compliance (GDPR, labor laws)
3. **Create Changesets**: Add Liquibase changesets for HR schema updates
4. **Privacy Impact**: Assess privacy implications of data changes
5. **Test Changes**: Comprehensive testing including privacy scenarios
6. **Documentation**: Document HR processes and data flows

### Key Database Components

#### Core HR Tables
- **employee**: Central employee information
- **position**: Job positions and organizational roles
- **department**: Organizational structure
- **employment_status**: Employee status tracking
- **compensation**: Salary and wage information

#### Process Management Tables
- **performance_review**: Employee evaluation records
- **time_off_request**: Leave and absence management
- **training_record**: Employee development and training
- **disciplinary_action**: HR disciplinary processes

## Testing Standards

### HR-Specific BDD Testing
- **Employee Lifecycle**: Hiring, promotions, transfers, terminations
- **Compliance Scenarios**: Privacy, labor law, and regulatory compliance
- **Reporting Requirements**: HR analytics and statutory reporting
- **Security Testing**: Access controls and data protection
- **Process Workflows**: HR business process validation

### Privacy and Security Testing
- **Data Access Controls**: Role-based access to sensitive HR data
- **Privacy Compliance**: GDPR and other privacy regulation compliance
- **Audit Trails**: HR action logging and audit capabilities
- **Data Retention**: Proper data lifecycle and retention policies

## Compliance Considerations

### Regulatory Compliance
- **Labor Laws**: Local and international labor law compliance
- **Privacy Regulations**: GDPR, CCPA, and other privacy laws
- **Equal Opportunity**: Anti-discrimination and equal opportunity compliance
- **Wage and Hour**: Fair labor standards and wage requirements

### Data Privacy
- **Personal Data Protection**: Secure handling of employee personal information
- **Consent Management**: Employee consent for data processing
- **Data Subject Rights**: Support for privacy rights requests
- **Cross-border Transfers**: International data transfer compliance

## Docker Integration

The module produces a Docker container named `erpmicroservices/human_resources-database` that:
- Extends PostgreSQL base image
- Initializes HR database schema with appropriate security settings
- Includes reference data for HR processes
- Supports HR compliance and reporting requirements
- Integrates with HR endpoint services and applications

## Dependencies and Requirements

### Runtime Dependencies
- PostgreSQL database server (12+ recommended)
- Docker (for containerized deployment)
- Liquibase (managed through npm scripts)

### Development Dependencies
- Node.js and npm
- Cucumber.js testing framework
- Chai assertion library
- pg-promise for database connectivity

## Performance Considerations

### HR-Specific Optimizations
- **Employee Lookup**: Fast employee search and retrieval
- **Reporting Performance**: Efficient HR analytics and reporting queries
- **Compliance Queries**: Optimized regulatory reporting performance
- **Audit Log Performance**: Efficient audit trail storage and retrieval

### Security Optimizations
- **Access Control Performance**: Fast role-based access control validation
- **Encryption**: Performance-efficient encryption for sensitive data
- **Session Management**: Secure and efficient user session handling

## Integration Points

### HR Applications
- **HRIS Integration**: Human Resource Information System connectivity
- **Payroll Systems**: Integration with payroll processing systems
- **Benefits Administration**: Connection with benefits management platforms
- **Time Tracking Systems**: Integration with time and attendance systems

### Compliance Systems
- **Regulatory Reporting**: Automated compliance report generation
- **Audit Systems**: Integration with internal and external audit processes
- **Background Check Services**: Third-party screening service integration

## Important Notes

- **Privacy Critical**: Handles highly sensitive personal employee information
- **Compliance Mandatory**: Must meet strict regulatory and legal requirements
- **Security Essential**: Requires robust security controls and access management
- **Audit Trail Required**: Comprehensive logging for compliance and legal purposes
- **Data Retention**: Must implement proper data lifecycle and retention policies
- **Performance Sensitive**: HR processes often require real-time data access