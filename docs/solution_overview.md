# Solution Overview

## Introduction

This solution provides cost-effective way to host a static website on AWS using Terraform. The architecture uses Amazon S3 for reliable object storage and Amazon CloudFront for global content delivery, ensuring high availability, low latency, and enhanced security for the website.

## Architecture Overview

1. The solution implements a serverless static website hosting pattern that eliminates the need for traditional web servers or application servers.
2. Content is stored in a private Amazon S3 bucket and served globally through Amazon CloudFront, a Content Delivery Network (CDN) that caches content at edge locations worldwide.

### High-Level Architecture

```
Internet Users
      │
      ▼
CloudFront Distribution (CDN)
      │
      ▼
Origin Access Control (OAC)
      │
      ▼
Amazon S3 Bucket (Private)
      │
      ▼
Static Website Files
(index.html, 404.html)
```

## Key Components

### 1. Amazon S3 Bucket
- **Purpose**: Secure storage for static website files
- **Configuration**:
  - Bucket versioning enabled for rollback capabilities
  - Server-side encryption (AES256) for data protection
  - Public access completely blocked for security
  - Ownership controls set to "BucketOwnerPreferred"
- **Naming**: Uses a base name with a random 10-character suffix to avoid naming conflicts

### 2. Amazon CloudFront Distribution
- **Purpose**: Global content delivery and caching
- **Features**:
  - IPv6 enabled for modern networking
  - HTTP/2 and HTTP/3 support for improved performance
  - Automatic HTTPS redirection for security
  - Custom error pages (404.html) for better user experience
  - Price Class 100 (covers US, Canada, Europe) for cost optimization
- **Cache Behavior**:
  - Uses AWS-managed "CachingOptimized" policy for static content
  - CORS-S3Origin policy for proper cross-origin resource sharing
  - Only GET and HEAD methods allowed

### 3. Origin Access Control (OAC)
- **Purpose**: Secure access to S3 bucket exclusively through CloudFront
- **Benefits**:
  - Prevents direct public access to S3 bucket
  - Uses AWS Signature Version 4 (SigV4) for request signing
  - Eliminates need for complex bucket policies

### 4. Static Website Content
- **Files**: index.html (homepage) and 404.html (error page)
- **Content**: Simple HTML pages displaying "Lano Puljic's website"
- **Deployment**: Automatically uploaded to S3 via Terraform

## Security Features

### Data Protection
- **Encryption**: All objects encrypted at rest using AES256
- **Access Control**: Bucket completely private, accessible only via CloudFront
- **Network Security**: HTTPS enforced, no HTTP traffic allowed

### Infrastructure Security
- **Principle of Least Privilege**: OAC restricts S3 access to CloudFront only
- **Default Tags**: Resources tagged with project, environment, and owner information
- **Randomization**: Bucket names include random strings to prevent name duplication.

## Performance Optimizations

### Caching Strategy
- **Edge Locations**: Content cached globally via CloudFront's 200+ edge locations
- **Cache Policies**: AWS-managed optimized policies for static content
- **Error Caching**: 404 responses cached for 5 minutes to reduce origin load

### Delivery Optimizations
- **HTTP Versions**: Support for HTTP/2 and HTTP/3 for faster connections
- **Compression**: Automatic gzip compression for text-based content
- **IPv6 Support**: Dual-stack networking for improved compatibility

## Cost Optimization

### Resource Selection
- **Price Class**: CloudFront Price Class 100 (most cost-effective option)
- **Region**: Default deployment in us-west-2 (Oregon) for AWS cost benefits
- **Scaling**: Serverless architecture scales automatically with demand

### Operational Costs
- **No Server Management**: Eliminates EC2 or other compute costs
- **Pay-per-Use**: Only pay for storage and data transfer actually used
- **Caching Benefits**: Reduced S3 requests through CloudFront caching
