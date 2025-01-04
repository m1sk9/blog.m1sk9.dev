+++
title = "Vercel は Zola 環境を用意していない"
date = 2025-01-05
# updated =
description = "プリセットに Zola を用意しているのに無いのは煽っているのか?"
[taxonomies]
categories = ["Dev"]
tags = ["Web"]
[extra]
lang = "ja"
toc = true
math = true
mermaid = true
+++

このブログを Zola という Rust 製の SSG に移植した際，デプロイ先に Cloudflare Pages と Vercel を検討した．

[Cloudflare Pages はビルドイメージ等の問題で Zola の環境がうまく使えないらしい](https://github.com/cloudflare/pages-build-image/issues/3#issuecomment-1646873666)．実際私も同じ問題に遭遇したがもう1年近く放置されているので期待するのはやめた．

Vercel も Cloudflare Pages と同じように[プリセットに Zola を用意している](https://www.getzola.org/documentation/deployment/vercel/)ので，これを使えば問題ないだろうと思った．

だが，どうやら Vercel もビルド環境に Zola を用意していないらしい．

![](/assets/post/image/note-of-deploy-zola-project-to-vercel/vercel-log.png)

Vercel に石を投げてもいいんだが，放置される未来が見えるし Vercel 上で解決方法を探すことにした．

## 環境変数で Zola のバージョンを指定する

Vercel は各パッケージや環境のバージョンを環境変数で指定できる．これは Cloudflare Pages でも同様[^1]．

Zola のバージョンを指定するためには，`ZOLA_VERSION` という環境変数を設定すればいい．

この記事の公開時点(`2025/01/05`)での最新バージョンは `0.19.2` なので，以下のように設定する．

![](/assets/post/image/note-of-deploy-zola-project-to-vercel/vercel-env.png)

## Submodule 側の設定

テーマをインストールしている場合は Submodule 側の設定も必要になる．

[Vercel は SSH での Git URL で設定されている Submodule のリポジトリをチェックアウトすることはできない](https://vercel.com/docs/deployments/build-features#git-submodules) (多分)[^2]．

そのため，Submodule のリポジトリを HTTPS で設定し直す必要がある．

`.git/config`:

```gitconfig
[submodule "themes/serene"]
	url = https://github.com/m1sk9-lib/serene.git
	active = true
```

`.gitmodules`:

```gitmodules
[submodule "themes/serene"]
	path = themes/serene
	url = https://github.com/m1sk9-lib/serene.git
```

----

[^1]: 最も Cloudflare Pages は最新の Node.js をデフォルトでサポートしないというとんでも運用なので，この環境変数ノウハウはよく使う．
[^2]: 出来る方法もおそらく存在はするが，`git pull` するだけなんだから HTTPS を使うが一番手っ取り早いだろう．
