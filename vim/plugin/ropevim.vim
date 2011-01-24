function! LoadRope()
python << EOF
try:
    import ropevim
except ImportError:
    pass
EOF
endfunction

call LoadRope()
