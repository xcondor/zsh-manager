import { MetadataRoute } from 'next';

export default function sitemap(): MetadataRoute.Sitemap {
  const baseUrl = 'https://maczsh.com';
  const lastModified = new URL(baseUrl).pathname === '/' ? new Date() : new Date('2024-05-11');

  const routes = [
    '',
    '/docs',
    '/pricing',
    '/contact',
    '/changelog',
    '/privacy',
    '/terms',
    '/refund',
    '/docs/installation',
    '/docs/manual',
    '/docs/cloud-sync',
    '/docs/config-doctor',
    '/docs/python-manager',
    '/docs/snapshots',
    '/docs/terminal-master',
  ];

  return routes.map((route) => ({
    url: `${baseUrl}${route}`,
    lastModified,
    changeFrequency: route.includes('docs') ? 'weekly' : 'monthly',
    priority: route === '' ? 1 : route.includes('docs') ? 0.8 : 0.5,
  }));
}
