import Hummingbird
import Mustache

struct HTML: ResponseGenerator {
    let html: String

    public func response(from request: Request, context: some BaseRequestContext) throws -> Response {
        let buffer = context.allocator.buffer(string: self.html)
        return .init(status: .ok, headers: [.contentType: "text/html"], body: .init(byteBuffer: buffer))
    }
}

struct PagesController {
    let mustacheLibrary: MustacheLibrary

    func addRoutes(to router: Router<some RequestContext>) {
        router.get("/", use: self.indexHandler)
    }

    @Sendable func indexHandler(request: Request, context: some RequestContext) -> HTML {
        let html = self.mustacheLibrary.render((), withTemplate: "index")!
        return HTML(html: html)
    }
}
