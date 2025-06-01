## 版本管理

## gh - init repo
```bash
git config --global init.defaultBranch main
git init
# git branch -m main
```

## set git user name and email
```bash
git config --global user.name "yemiancheng"; git config --global user.email "ymc.github@gmail.com";
```

## opv - basic files
```bash
git add .dockerignore .editorconfig .gitattributes LICENSE README.md .env; git commit -m "build(core): init directory constructure";

```

## opv - docs
```bash

git add docs/*.md; git commit -m "docs(core): update docs";
git add docs/*.md; git commit -m "docs(core): update docs";

git add README.md; git commit -m "docs(core): set tags format in readme";
git add README.md; git commit -m "docs(core): put usage";

git add docs/opv*.md; git commit -m "docs(core): put note for opv.this.repo";
git add docs/opv*.md; git commit -m "docs(core): rename repo name";
git add docs/opv*.md; git commit -m "docs(core): rename repo description";
git add docs/opv*.md; git commit -m "docs(core): reuse old key pairs";

git add docs/*alpine.versions.md; git commit -m "docs(core): add alpine versions";
```

## opv - scripts
```bash
git add scripts/*.sh; git commit -m "build(core): init scripts"; 
git add scripts/*.sh; git commit -m "build(core): update scripts"; 
```

## opv - assets
```bash
git add assets/*.svg; git commit -m "assets(core): init assets"; 
git add assets/*.svg; git commit -m "assets(core): update assets"; 

```

## opv - secrets
```bash
git add secrets/*; git commit -m "build(core): init directory constructure";
```

## opv - sql-backup
```bash
git add sql-backup/*; git commit -m "build(core): init directory constructure";
```

## opv - sql-init
```bash
git add sql-init/*; git commit -m "build(core): init directory constructure";
```

## opv - sql-config
```bash
git add my.cnf; git commit -m "build(core): set mysqld config";
```

## opv - env files
```bash
git add .env ; git commit -m "build(core): use env file";
```

## opv - workflows fiels
```bash
git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): init github workflows";
git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): use Dockerfile-alpine";

git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): use sql-init as path trigger and hand trigger";
git add .github/workflows/check-environment.yml; git commit -m "build(core): check environment";
git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): fix runs-on";
git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): del unused platforms";
git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): fix image tags format";
git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): allow this file as trigger (dryrun)";
git add .github/workflows/build.yml; git commit -m "build(core): set tags for readme";
git add .github/workflows/build.yml; git commit -m "build(core): del 3.20";
git add .github/workflows/build.yml; git commit -m "build(core): fix passed env";
git add .github/workflows/build.yml; git commit -m "build(core): use workflow like pnpm-docker";
git add .github/workflows/build.yml; git commit -m "build(core): fix test";
git rm .github/workflows/docker-publish-alpine.yml;git commit -m "build(core): del unused files";
```

## opv - dockerfiles
```bash

git add Dockerfile-alpine; git commit -m "build(core): init dockerfile";
git add Dockerfile; git commit -m "build(core): sync to Dockerfile-alpine";


git add Dockerfile; git commit -m "build(core): init dockerfile";
git add Dockerfile-alpine; git commit -m "build(core): use ALPINE_VERSION as arg to set alpine version";

```