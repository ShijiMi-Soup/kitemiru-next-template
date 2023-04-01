import Head from 'next/head'
import Image from 'next/image'

/**
 * # トップページ
 *
 * - テストで，タイトルとH1だけ設定しています．
 * - [Tailwindcss](https://tailwindcss.com/)でスタイルしています．
 */
export default function Home() {
  return (
    <div>
      <Head>
        <title>Kitemiru Next</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main>
        <h1 className="text-4xl text-red-400">Kitemiru Next</h1>
        <p>Some text. HELLO, WORLD!!!</p>
      </main>
    </div>
  )
}
