# Alternative Solution

For prototyping I feel like this was the cleanest and quickest solution to build
and to get result that I am after.

### My solution ( most common and cost effective)
* Server content from Amazon S3
- CloudFront

## Alternative Solutions

1. AWS Amplify Hosting
  - Full managed hosting platform with build in CI/
  - Connects directly to GitHub
  - Automatically Builds and deploys.
  - Provides SSL, custom domain, redirects.

   **Pros**: Easy deployment, CI/CD  builtin, global.\
   **Cons**: More expansive then S3+CloudFront for simple static website.

2. Amazon EC2 with NGINX
  - Deploy and Configure EC2 Instance, install NGINX and server static website
  - Use Route53 for DNS and ACM for SSL certificates

**Pros**: Maximum flexibility \
**Cons** : Must handle scaling, patching, and CDN configuration manually,
       basically this is full configurable config.

3. AWS CloudFront + Lambda@Edge / CloudFront Functions (Without S3)
  - You store assets in GitHub, DynamoDB  or and external source and use
    Lambda@Edge to dynamically server and rewrite requests.

**Pros**: Extremely performant, edge-optimized\
**Cons**: Complex setup, requires coding and deployment logic


### Outcome

While researching, I came across several other solutions that could be used to
achieve this task. However, most of these options would be overkill for our specific needs.

Other possible solutions include:

1. AWS Elastic Beanstalk
2. AWS App Runner
3. Amazon Lightsail Static IP + NGINX
4. AWS AppSync + S3 + CloudFront Hybrid

Conclusion:

I still believe that we chose the right solution based on the requirements
specified in the document.
