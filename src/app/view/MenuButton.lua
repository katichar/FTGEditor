--
-- Author: rsma
-- Date: 2015-12-08 17:49:26
--
local button ={}
function button.create(PLables,PSize,POnClick)
	local button = cc.ui.UIPushButton.new(PUSH_BUTTON_IMAGES, {scale9 = true})
        :setButtonSize(PSize.width or 100, PSize.height or 60)
        :setButtonLabel("normal", cc.ui.UILabel.new({
            UILabelType = 2,
            text = PLables.normal or "",
            size = 18
        }))
        :setButtonLabel("pressed", cc.ui.UILabel.new({
            UILabelType = 2,
            text = PLables.pressed or "",
            size = 18,
            color = cc.c3b(255, 64, 64)
        }))
        :setButtonLabel("disabled", cc.ui.UILabel.new({
            UILabelType = 2,
            text = PLables.disabled or "",
            size = 18,
            color = cc.c3b(0, 0, 0)
        }))
        :onButtonClicked(function(event)
        	if POnClick then
        		POnClick()
        	end
        end)
    return button
end
return button