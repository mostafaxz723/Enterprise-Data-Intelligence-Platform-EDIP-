import './globals.css';
import type { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'أطلس الطاقة المتجددة الحي لمصر',
  description: 'منصة ذكية لاختيار مواقع محطات الشمس والرياح في مصر وتوقع إنتاجها',
};

const LINKS: [string, string][] = [['/', 'الرئيسية'], ['/map/', 'الخريطة'], ['/compare/', 'المقارنة'], ['/forecast/', 'التوقع'], ['/simulator/', 'المحاكي'], ['/assistant/', 'المساعد'], ['/methodology/', 'المنهجية']];

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ar" dir="rtl">
      <body>
        <nav className="wrap" style={{ display: 'flex', gap: 16, flexWrap: 'wrap' }}>
          {LINKS.map(([h, t]) => <Link key={h} href={h}>{t}</Link>)}
        </nav>
        {children}
      </body>
    </html>
  );
}
