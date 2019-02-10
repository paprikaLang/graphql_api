### Apollo

> [Apollo](https://www.apollographql.com) allows you to execute queries and mutations against a GraphQL server, and returns results as query-specific Swift types. This means you don’t have to deal with parsing JSON, or passing around dictionaries and making clients cast values to the right type manually. You also don’t have to write model types yourself, because these are generated from the GraphQL definitions your UI uses

Raywenderlich 有篇[Getting started with GraphQL & Apollo on iOS](https://www.raywenderlich.com/158433/getting-started-graphql-apollo-ios)可以帮助我们理解上面这段关于 Apollo 的概述. 作者 Nikolas Burk 在 Xcode 的 **Build Phases** 中添加了这样一段脚本

```bash
$APOLLO_FRAMEWORK_PATH/check-and-run-apollo-codegen.sh generate $(find . -name '*.graphql') --schema schema.json --output API.swift
```

大意就是: **找到 '*.graphql' 文件 并生成 API.swift**.

脚本中的 schema.json 需要 Graphcool 提供的 `__SIMPLE_API_ENDPOINT__` 才能获得.
```bash
apollo-codegen download-schema __SIMPLE_API_ENDPOINT__ --output schema.json
```

Graphcool 是一款用来开发和部署生产就绪的GraphQL微服务器的 BaaS , 下面 React 的例子中 endpoint uri 也可以通过 

`graphcool init --schema http://graphqlbin.com/conferences.graphql --name xxx` 获得.

<img src="https://paprika-dev.b0.upaiyun.com/batJsCcG4BstN2ldI5ExG1aXRNTM8riizIWhPMWE.jpeg" width="400"/>

<br>

### Prisma

这里要说的 Prisma 不是一款软件.

<img src="https://paprika-dev.b0.upaiyun.com/7UsgbKkiHibaxzm7VHl52DlqkGzusASOm3CfPWip.jpeg" width="300"/>
<br>

> [Prisma](https://www.prisma.io) is a performant open-source GraphQL ORM-like layer doing the heavy lifting in your GraphQL server. 

你可以把 Prisma 想成是一款最强劲的汽车引擎, Graphcool 是一台刚出厂的华丽跑车. 然后再去理解下面这段 Nikolas Burk 对 GCF ( 指 Graphcool )的想法:

<img src="https://paprika-dev.b0.upaiyun.com/oazluBb9OiYh8FV3INdtLcplP8fccezrw3g4P5RH.jpeg" width="600"/>

<br>


1. **开发流程**

<img src="https://paprika-dev.b0.upaiyun.com/pgzvm4RAbksDtJjr9DtkxhfpsS6lYLPtUFasYfXv.jpeg" width="600"/>

生成的 prisma.yml 文件可以做如下配置:
```
datamodel：数据库模型
endpoint： Prisma API的HTTP端点
secret：   JWT
schema：   Prism API的GraphQL schema的路径
subscriptions：订阅webhooks的配置
seed：   指向包含突变的种子数据文件
custom： 用于提供可在prisma.yml其他地方引用的变量

```

<img src="https://paprika-dev.b0.upaiyun.com/VBJlYjN5yYK9LtLwplGMg6qgc8HwDYNCLifgXORV.jpeg" width="600"/>

可以在 subscriptions 里 hook `prisma deploy` , 并 get-schema .

```
graphql get-schema --endpoint http://localhost:4466 --output prisma.graphql --no-all
```
graphql-yoga 设置 server 的 db 参数时会用到它 prisma-binding . 
```JavaScript
const { Prisma } = require('prisma-binding')

const prisma = new Prisma({
  typeDefs: 'prisma.graphql',
  endpoint: 'http://localhost:4466'
})
```

<br>

2. **部署 Heroku**

<img src="https://paprika-dev.b0.upaiyun.com/FJQumz7HAHSIkvReLWbhfn41oN82dVmAbIkOaBhs.jpeg" width="400"/>


```bash
// 选择 TypeScript
graphql create heroku-demo
```
prisma.yml :
```
// 改用刚创建的 heroku server
endpoint: https://heroku-test11.herokuapp.com/heroku-demo/dev
```
index.ts :
```JavaScript
db: new Prisma({
  // 同理
  endpoint: 'https://heroku-test11.herokuapp.com/heroku-demo/dev', 
  debug: true, 
})
```
```
//部署 service
prisma deploy
```
```
yarn start
```
<img src="https://paprika-dev.b0.upaiyun.com/EaAQjxrpf5rSHOF1NvX1lrx2UG76lITlduvBTg74.jpeg" width="800"/>

```
"scripts": {
    "postinstall": "tsc",
    "start": "ts-node src/index.ts",
    ... ...
  },
```
Procfile :
```
web: node dist/index.js
```
```bash
heroku create 
git push heroku master
```
```bash
git remote set-url --add --push heroku https://github.com/paprikaLang/GraphQL-O.git
git remote set-url --add --push heroku https://git.heroku.com/secuxxxxxxxxxxxx731.git

```

git remote -v :
```bash
heroku	https://git.heroku.com/secuxxxxxxxxxx731.git (fetch)
heroku	https://github.com/paprikaLang/GraphQL-O.git (push)
heroku	https://git.heroku.com/secuxxxxxxxxxx731.git (push)
```
这样, GitHub 和 Heroku 可以同步上传代码了.

<br>

### Gatsby

[Contentful](https://www.contentful.com) 部署 GraphQL 所需的 database:

<img src="https://paprika-dev.b0.upaiyun.com/XxZ0rgSVaSVd98aFE4Gm7aXYMyWgpIYmEF0lIGVX.jpeg" width="600"/>

<img src="https://paprika-dev.b0.upaiyun.com/6fhqCflN91kFYbRg30phczgVynpMWnzR6JFsnE4T.jpeg" width="600"/>

Gatsby new 创建好项目并添加 Contentful 配置项:

```
{
  resolve:'gatsby-source-contentful',
  options: {
    spaceId:'SPACE_ID',
    accessToken:'ACCESS_TOKEN'
  }
}
```
`gatsby develop` 会加载配置好的 Contentful data. 

<img src="https://paprika-dev.b0.upaiyun.com/W3R85sribgflBY0TsmOff9l8Y0crRRmaoYEJZxP8.jpeg" width="600"/>

```
import { StaticQuery, graphql } from 'gatsby'

const Layout = ({ children }) => (
  <StaticQuery
    query={graphql`
      query SiteTitleQuery {
      	...
        allContentfulLink(sort: {fields: [createdAt],order: ASC}){
          edges{
            node{
              title
              url
              createdAt }}}}
    `}
    render={data => ()} /> )

```




 


