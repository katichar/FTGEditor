--
-- Author: rsma
-- Date: 2015-06-30 16:28:53
--
local tbd={}
function tbd.bounceHeight(i_pernum)
	return function (i_role)
		return i_role.bounceHeight * i_pernum
	end
end
return tbd