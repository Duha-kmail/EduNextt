# Email Configuration Setup Guide

## Overview
The **Forgot Password** feature requires SMTP email configuration to send password reset codes to users. This guide explains how to configure the email service.

## Current Configuration
- **Email Provider**: Gmail (SMTP)
- **Server**: smtp.gmail.com
- **Port**: 587 (TLS)
- **Account**: edunext.contact@gmail.com

## Setup Instructions

### Option 1: Using Gmail App Password (Recommended)

If your Gmail account has **2-Factor Authentication enabled**, you must use an App Password:

1. Go to [Google Account Security](https://myaccount.google.com/security)
2. Enable 2-Step Verification if not already enabled
3. Go to **App passwords** section (only appears if 2FA is enabled)
4. Select "Mail" and "Windows Computer"
5. Google will generate a 16-character password
6. Copy this password

### Option 2: Direct Gmail Password (If 2FA is disabled)
If your Gmail account does **NOT have 2-Factor Authentication**:
- You can use your regular Gmail password
- However, you may need to enable "Less secure app access" in Gmail settings

## Applying the Password

### Method A: Direct Configuration (Development)
Update `backend/appsettings.json`:
```json
"Email": {
  "Password": "YOUR_GMAIL_APP_PASSWORD_HERE"
}
```

### Method B: Environment Variable (Recommended for Production)
Set an environment variable:
```
Email__Password=YOUR_GMAIL_APP_PASSWORD_HERE
```

This overrides the appsettings.json value and keeps sensitive data out of source control.

### Method C: User Secrets (Development Best Practice)
In the `backend` folder, run:
```bash
dotnet user-secrets init
dotnet user-secrets set "Email:Password" "YOUR_GMAIL_APP_PASSWORD_HERE"
```

User secrets are stored securely and only for development.

## Verification

To test the configuration:
1. Start the backend server
2. Open the frontend login page
3. Click "Forgot Password"
4. Enter a valid registered email
5. Check if you receive the password reset code

## Troubleshooting

| Error | Cause | Solution |
|-------|-------|----------|
| "503 Service Unavailable" | Email settings missing/incorrect | Check that Email.Password is set |
| "Authentication failed" | Wrong Gmail password | Verify App Password or enable less secure apps |
| "Connection timeout" | SMTP server unreachable | Check firewall/network settings |
| "Email not received" | May be in spam folder | Check spam/junk emails |

## Feature Flow

```
User enters email
    ↓
Frontend calls POST /api/auth/forgot-password
    ↓
Backend generates 6-digit OTP
    ↓
SMTP sends email with OTP to user
    ↓
User receives code and enters it
    ↓
Backend verifies OTP
    ↓
User sets new password
    ↓
Password is updated and user can login
```

## Security Notes

- **Never commit passwords** to version control
- Always use App Passwords for 2FA-enabled accounts
- Consider environment variables for production deployments
- Passwords are only used for SMTP authentication, not stored in database
