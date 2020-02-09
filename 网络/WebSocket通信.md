# 一、WebSocket 是什么
WebSocket 是一种网络通信协议。2009年诞生。WebSocket 是HTML 5开始提供的一种在单个TCP连接上进行双全工(full-duplex)通讯的协议。没有 Request 和 Response 的概念，使用WebSocket建立连接的两端，既是 Reuqest ，也是 Response。连接一旦建立，双方就可以随时向对方发送消息。

<br/>

# 二、为什么用WebSocket
在没有 WebSocket 之前，Web为了实现即时通信，有以下几种方案，最初的polling，到之后的long polling，最后的基于 streaming 方式，再到最后的SSE，也是经历了几个不同的演进方式。

## 2-1、短轮询polling方式
这种方式下，是不适合获取实时信息的，客户端和服务器之间会一直进行连接，每隔一段时间就询问一次。客户端会轮询，有没有新消息。这种方式连接数会很多，一个接受，一个发送。而且每次发送请求都会有 HTTP 的 Header，会很耗流量，也会消耗 CPU 的利用率。

这个阶段可以看到，一个 Request 对应一个 Response，一来一回一来一回。

在 Web 端，短轮询用 AJAX JSONP Polling 轮询实现。

由于 HTTP 无法无限时长的保持连接，所以不能在服务器和 Web 浏览器之间频繁的长时间进行数据推送，所以 Web 应用通过通过频繁的异步 JavaScript 和 XML (AJAX) 请求来实现轮循。

- 优点：短连接，服务器处理简单，支持跨域、浏览器兼容性较好。
- 缺点：有一定延迟、服务器压力较大，浪费带宽流量、大部分是无效请求。

<br/>

## 2-2、长轮询 long polling
长轮询是对轮询的改进版，客户端发送 HTTP 给服务器之后，有没有新消息，如果没有新消息，就一直等待。直到有消息或者超时了，才会返回给客户端。消息返回后，客户端再次建立连接，如此反复。这种做法在某种程度上减小了网络带宽和 CPU 利用率等问题。

这种方式也有一定的弊端，实时性不高。如果是高实时的系统，肯定不会采用这种办法。因为一个 GET 请求来回需要 2个 RTT，很可能在这段时间内，数据变化很大，客户端拿到的数据已经延后很多了。

另外，网络带宽低利用率的问题也没有从根源上解决。每个 Request 都会带相同的 Header。

对应的，Web 也有 AJAX 长轮询，也叫 XHR 长轮询。

客户端打开一个到服务器端的 AJAX 请求，然后等待响应，服务器端需要一些特定的功能来允许请求被挂起，只要一有事件发生，服务器端就会在挂起的请求中送回响应并关闭该请求。客户端在处理完服务器返回的信息后，再次发出请求，重新建立连接，如此循环

- 优点：减少轮询次数，低延迟，浏览器兼容性较好。
- 缺点：服务器需要保持大量连接。

<br/>

## 2-3、基于流 Comet Streaming
### 2-3-1、基于 Iframe 及 htmlfile 的流（Iframe Streaming）
iframe 流方式是在页面中插入一个隐藏的 iframe，利用其 src 属性在服务器和客户端之间创建一条长链接，服务器向 iframe 传输数据（通常是 HTML，内有负责插入信息的 JavaScript），来实时更新页面。iframe 流方式的优点是浏览器兼容好。

使用 iframe 请求一个长连接有一个很明显的不足之处：IE、Morzilla Firefox 下端的进度栏都会显示加载没有完成，而且 IE 上方的图标会不停的转动，表示加载正在进行。

Google 的天才们使用一个称为 “htmlfile” 的 ActiveX 解决了在 IE 中的加载显示问题，并将这种方法用到了 gmail+gtalk 产品中。Alex Russell 在 “What else is burried down in the depth's of Google's amazing JavaScript?”文章中介绍了这种方法。Zeitoun 网站提供的 comet-iframe.tar.gz，封装了一个基于 iframe 和 htmlfile 的 JavaScript comet 对象，支持 IE、Mozilla Firefox 浏览器，可以作为参考。

- 优点：实现简单，在所有支持 iframe 的浏览器上都可用、客户端一次连接、服务器多次推送。
- 缺点：无法准确知道连接状态，IE浏览器在 iframe 请求期间，浏览器 title 一直处于加载状态，底部状态栏也显示正在加载，用户体验不好（htmlfile 通过 ActiveXObject 动态写入内存可以解决此问题）。

<br/>

### 2-3-2、AJAX multipart streaming（XHR Streaming）
实现思路：浏览器必须支持 multi-part 标志，客户端通过 AJAX 发出请求 Request，服务器保持住这个连接，然后可以通过 HTTP1.1 的 chunked encoding 机制（分块传输编码）不断 push 数据给客户端,直到 timeout 或者手动断开连接。

- 优点：客户端一次连接，服务器数据可多次推送。
- 缺点：并非所有的浏览器都支持 multi-part 标志。

<br/>

### 2-3-3、Flash Socket（Flash Streaming）
实现思路：在页面中内嵌入一个使用了 Socket 类的 Flash 程序，JavaScript 通过调用此 Flash 程序提供的 Socket 接口与服务器端的 Socket 接口进行通信，JavaScript 通过 Flash Socket 接收到服务器端传送的数据。

- 优点：实现真正的即时通信，而不是伪即时。
- 缺点：客户端必须安装 Flash 插件；非 HTTP 协议，无法自动穿越防火墙。

<br/>

### 2-3-4、Server-Sent Events
服务器发送事件（SSE）也是 HTML5 公布的一种服务器向浏览器客户端发起数据传输的技术。一旦创建了初始连接，事件流将保持打开状态，直到客户端关闭。该技术通过传统的 HTTP 发送，并具有 WebSockets 缺乏的各种功能，例如自动重新连接、事件 ID 以及发送任意事件的能力。

SSE 就是利用服务器向客户端声明，接下来要发送的是流信息（streaming），会连续不断地发送过来。这时，客户端不会关闭连接，会一直等着服务器发过来的新的数据流，可以类比视频流。SSE 就是利用这种机制，使用流信息向浏览器推送信息。它基于 HTTP 协议，目前除了 IE/Edge，其他浏览器都支持。

SSE 是单向通道，只能服务器向浏览器发送，因为流信息本质上就是下载。

服务器向浏览器发送的 SSE 数据，必须是 UTF-8 编码的文本，具有如下的 HTTP 头信息。

```
Content-Type: text/event-stream
Cache-Control: no-cache
Connection: keep-alive
```

上面三行之中，第一行的Content-Type必须指定 MIME 类型为event-steam

- 优点：适用于更新频繁、低延迟并且数据都是从服务端发到客户端。
- 缺点：浏览器兼容难度高。

<br/>


见 [全双工通信的 WebSocket](https://mp.weixin.qq.com/s/VI5Th5mePJkPbD1ea0u1EA)