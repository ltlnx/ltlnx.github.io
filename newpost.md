# i3wm中，在不同工作區中用同一個快速鍵開啟不同程式
用過i3的人都知道，在i3裡按$mod+Enter (Return) 可以開啟一個終端機視窗。但現在我把每一個i3的工作區都命名好了，如果我想在第一個工作區按$mod+Enter時開啟終端機，在第二個工作區時開啟編輯器，在第三個工作區開啟檔案管理器之類的，要怎麼做呢？
1. 先寫shell script：

    #!/bin/bash
    # Open different apps on workspace with i3-msg and jq
    # Solution adapted from https://faq.i3wm.org/question/6200/obtain-info-on-current-workspace-etc.1.html
    curws=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name | '.[0:1]')
    case $curws in
    1) 'alacritty' ;; # 如果在第一個工作區就執行這個程式
    2) 'geany' ;;     # 如果在第二個工作區就執行這個程式
    3) 'nautilus' ;;  # 如果在第三個工作區就執行這個程式
    4) 'firefox' ;;   # 如果在第四個工作區就執行這個程式
    esac

先用`i3-msg`獲取工作區json資訊，用`jq`過濾後，再用`case`決定要跑哪個程式。`alacritty`、`geany`等是程式名稱，可自行替換。

2. 存在某個地方（之後會以`path/to/script`來表示）。
3. `chmod +x path/to/script(script的所在位置)`
4. 用編輯器打開i3的config，找到`bindsym $mod+Return`那一行，可能顯示如下：

    bindsym $mod+Return exec --no-startup-id i3-sensible-terminal
    
5. 將那行替換成：

    bindsym $mod+Return exec path/to/script(script的所在位置)
    
6. 存檔，重啟i3（`$mod+Shift+r`），在不同工作區按下`$mod+Enter`看看有沒有成功。

