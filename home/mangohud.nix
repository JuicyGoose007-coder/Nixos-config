{ ... }:

{
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;

    settings = {
      fps = true;
      frame_timing = 1;
      gpu_stats = true;
      cpu_stats = true;
      ram = true;
      vram = true;
      position = "top-left";
    };
  };
}
