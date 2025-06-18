import './globals.css'

export const metadata = {
  title: 'LeEnglish TOEIC',
  description: 'Your comprehensive TOEIC learning platform',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className="bg-gray-50 min-h-screen">
        {children}
      </body>
    </html>
  )
}
