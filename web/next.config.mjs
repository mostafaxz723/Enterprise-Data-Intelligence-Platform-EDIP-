// Static export = the site is plain files -> free hosting on Cloudflare Pages / GitHub Pages / Vercel.
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: { unoptimized: true },
  eslint: { ignoreDuringBuilds: true },
  basePath: process.env.NEXT_PUBLIC_BASE_PATH || '',
};
export default nextConfig;
