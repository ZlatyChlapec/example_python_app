import aiohttp


async def hello(_request):
    return aiohttp.web.Response(text="Hello, it's me!")

application = aiohttp.web.Application()
application.add_routes([aiohttp.web.get('/', hello)])
