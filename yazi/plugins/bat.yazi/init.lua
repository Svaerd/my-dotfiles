local M = {}

function M:peek()
	local child = Command("bat")
		:arg({
			"--style",
			"plain",
			"--color",
			"always",
			tostring(self.file.url),
		})
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:spawn()

	local limit = self.area.h
	local i, lines = 0, ""
	repeat
		local next, event = child:read_line()
		if event == 1 then
			ya.err(tostring(event))
		elseif event ~= 0 then
			break
		end

		i = i + 1
		if i > self.skip then
			lines = lines .. next
		end
	until i >= self.skip + limit

	child:start_kill()
	if self.skip > 0 and i < self.skip + limit then
		ya.manager_emit(
			"peek",
			{ tostring(math.max(0, i - limit)), only_if = tostring(self.file.url), upper_bound = "" }
		)
	else
		lines = lines:gsub("\t", string.rep(" ", PREVIEW.tab_size))
		ya.preview_widgets(self, { ui.Paragraph.parse(self.area, lines) })
	end
end

function M:seek(units)
	local h = cx.active.current.hovered
	if h and h.url == self.file.url then
		local step = math.floor(units * self.area.h / 10)
		ya.manager_emit("peek", {
			tostring(math.max(0, cx.active.preview.skip + step)),
			only_if = tostring(self.file.url),
		})
	end
end

return M
