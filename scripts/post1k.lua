wrk.method = "POST"
wrk.body   = string.rep('0', 1024)
wrk.headers["Content-Type"] = "plain/text"
