# frontend

- kitmiru のフロントエンド

## 技術スタック

|                      |                                               |
| -------------------- | --------------------------------------------- |
| 言語                 | [TypeScript](https://www.typescriptlang.org/) |
| フレームワーク       | [Next.js](https://nextjs.org/)                |
| スタイリング         | [Tailwind CSS](https://tailwindcss.com/)      |
| テスト               | [Jest](https://jestjs.io/)                    |
| ドキュメンテーション | [TypeDoc](https://typedoc.org/)               |

## ディレクトリ構成

- 端末にて `tree -d --gitignore` で生成 (2023/03/02)

```shell
frontend
├── docker          Docker関連のファイル
├── docs            TypeDocで生成されるドキュメンテーション
│   ├── assets
│   └── functions
├── public
├── src
│   ├── pages       ページコンポーネント（Next.jsのルーティング）
│   └── styles      アプリ内を横断して使用するスタイリング
└── test            テスティング関連ファイル（Jest関連）
```
