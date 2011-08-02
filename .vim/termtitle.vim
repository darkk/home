if &term == "xterm" || &term == "rxvt-unicode" || &term == "rxvt"
  set title
  set t_ts=]0;
  set t_fs=
endif
if &term == "screen"
  set title
  set t_ts=k
  set t_fs=\
endif

