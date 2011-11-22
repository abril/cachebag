## HTTP Caching Goals

* Reduces quantity of HTTP requests sent (expiration mechanism)
* Reduces network bandwidth requirements (validation mechanism)

Semantic transparency: A cache behaves in a “semantically transparent” manner, with respect to a particular response, when its use affects neither the requesting client nor the origin server, except to improve performance. When a cache is semantically transparent, the client receives exactly the same response that it would have received had its request been handled directly by the origin server.
