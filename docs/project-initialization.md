# 最初の環境構築

最初の環境構築の備忘録を残しておきます

## 前提

下記のような構成を実現したい

- フロントエンド：
  - 言語：TypeScript
  - フレームワーク：Next
  - スタイリング：Tailwind CSS
  - テスト：Jest
  - ドキュメンテーション：TypeDoc
- バックエンド：未定
- Docker を利用
- Github Actions で firebase にデプロイ

## やれたこと・やれなかったこと

- やれたこと
  - 最後の項目以外の導入
- やれなかったこと
  - 2023/03 時点ではまだ firebase を用意していないので，最後の項目（Github Actions + firebase）は未実装
  - Jest は導入したが，Github Actions と連携させてはいない
  - push 時に eslint, prettier, Jest を走らせる設定はしていない（やるなら Huskey を使う？）

## 手順

### 1. `--example with-docker-compose` で Next アプリを作成

```bash
> yarn create next-app kitemiru-next --ts --example with-docker-compose
```

### 2. `yarn.lock`を生成する

```bash
> cd kitemiru-next/next-app
> yarn
> cd ..
```

### 3. Git をセットアップ

```bash
> git init && git add . && git commit -m "Initial commit"
> git remote add origin [git@github.com](mailto:git@github.com):dtgird/kitemiru-next.git
> git push origin main
```

### 4. Docker ファイルを一つのフォルダにまとめる

1.  `docker` フォルダを `next-app` の下に作成 (`kitemiru-next/next-app/docker`)
2.  Docker ファイル (`dev.Dockerfile`, `prod.Dockerfile`, `prod-without-multistage.Dockerfile`) を `docker` フォルダに移動
3.  docker-compose ファイルの `dockerfile` のパスを更新

### 5. Dockerfile と docker-compose ファイルを更新

1.  `/app` → `/app/next-app`
2.  `my_network` → `kitemiru_next_network`

### 6. makefile の作成

```makefile
# Make network
.PHONY: mk_network
mk_network:
docker network create kitemiru_next_network

# Remove network
.PHONY: rm_network
rm_network:
docker network rm kitemiru_next_network

# Development
.PHONY: dev
dev:
docker-compose -f docker-compose.dev.yml build
docker-compose -f docker-compose.dev.yml up

# Production
.PHONY: prod
prod:
docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml up -d

# Production (without mulitstage)
.PHONY: prod-without-multi-stage
prod-without-mulit-stage:
docker-compose -f docker-compose.prod-without-multistage.yml build
docker-compose -f docker-compose.prod-without-multistage.yml up -d

# Stop all running containers
.PHONY: kill
kill:
docker kill $(docker ps -aq) && docker rm $(docker ps -aq)

# Free space
.PHONY: free
free:
docker system prune -af --volumes
```

### 7. docker compose できるかチェック

1.  `make mk_network`
2.  `make dev`
3.  [http://localhost:3000/](http://localhost:3000/)にアクセス

### 8. [Tailwind CSS](https://tailwindcss.com/docs/guides/nextjs)を導入

1.  Tailwind をインストール

    ```bash
    > yarn install -D tailwindcss postcss autoprefixer
    > npx tailwindcss init -p
    ```

2.  `tailwind.config.js`を編集

    ```jsx
    /** @type {import('tailwindcss').Config} */
    module.exports = {
      content: ["./src/**/*.{js,ts,jsx,tsx}"],
      theme: {
        extend: {},
      },
      plugins: [],
    };
    ```

3.  `global.css`を編集

    ```css
    @tailwind base;
    @tailwind components;
    @tailwind utilities;
    ```

4.  Dockerfile を編集

    ```diff
      COPY next.config.js
    + COPY postcss.config.js
    + COPY tailwind.config.js
      COPY tsconfig.json
    ```

5.  動作確認

    1. 今のスタイルを削除 (`global.css`, `Home.modules.css`)
    2. `index.tsx` に tailwind でスタイリングしてみる
    3. `make dev`

### 9. eslint と prettier の追加

1.  `yarn add -D prettier eslint eslint-config-next eslint-plugin-tailwindcss eslint-config-prettier`
2.  `.eslintrc.json` と `.prettierrc` を作成 (適当に`create-next-app`したものからコピー)
3.  `package.json` の `script` を追加
    ```json
    "lint": "next lint",
    "format": "prettier --write --ignore-path .gitignore ."
    ```
4.  `yarn lint` と `yarn format` を試す

### 10. [Jest](https://nextjs.org/docs/testing#setting-up-jest-with-the-rust-compiler) を追加

1. `yarn add -D jest jest-environment-jsdom @testing-library/react @testing-library/jest-dom`
2. `jest.config.js` を作成
3. `test/index.test.tsx` を作成

   ```tsx
   import { render, screen } from "@testing-library/react";
   import "@testing-library/jest-dom/extend-expect";
   import Home from "../src/pages";

   describe("Home", () => {
     it("renders a heading", () => {
       render(<Home />);
       const heading = screen.getByRole("heading", {
         name: /Kitemiru Next/i,
       });
       expect(heading).toBeInTheDocument();
     });
   });
   ```

4. `"test": "jest"` を `package.json` の `script` に追加
5. `yarn test` を試す

### 11. [TypeDoc](https://typedoc.org/)を導入

1. `yarn add -D typedoc`

2. `typedoc.json` を追加

   ```json
   {
     // Comments are supported, like tsconfig.json
     "entryPoints": ["src/pages/index.ts"],
     "out": "docs"
   }
   ```

3. `"docs: typedoc"` を `package.json` の `scripts` に追加

4. `pages/index.tsx` でコメントを追加してみる

   ```diff
   + /**
   +  * # トップページ
   +  *
   +  * - テストで，タイトルとH1だけ設定しています．
   +  * - [Tailwindcss](https://tailwindcss.com/)でスタイルしています．
   +  */
     export default function Home() {
   ```

5. `yarn docs` でドキュメンテーション生成

6. VSCode 拡張機能の live server で `docs/index.html` を表示

   - image

7. `typedoc.json` に `"name": "Kitemiru Next"` を追加

   - `yarn docs` でドキュメンテーションを再生成すると，ヘッダーが更新されている

8. `next-app/README.md` を追加してドキュメンテーション再生成
   - image

### 12. `next-app` ディレクトリの名前を `frontend` に変更

Dockerfile や docker-compose ファイルのパスを更新
