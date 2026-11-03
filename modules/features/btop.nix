{ self, inputs, lib, ... }: {
  perSystem = { self', pkgs, ... }: {
    packages.btop = inputs.wrapper-modules.wrappers.btop.wrap {
      inherit pkgs;
      settings = {
        color_theme = "gruvbox";
        theme_background = true;
        truecolor = true;
        vim_keys = true;
        rounded_corners = true;
        terminal_sync = true;
        graph_symbol = "braille";
        presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
        shown_boxes = "cpu mem net proc";
        update_ms = 2000;
        proc_sorting = "cpu lazy";
        proc_colors = true;
        proc_gradient = true;
        proc_mem_bytes = true;
        proc_cpu_graphs = true;
        show_uptime = true;
        show_cpu_watts = true;
        check_temp = true;
        show_coretemp = true;
        temp_scale = "celsius";
        show_cpu_freq = true;
        clock_format = "%X";
        background_update = true;
        mem_graphs = true;
        show_swap = true;
        swap_disk = true;
        show_disks = true;
        only_physical = true;
        use_fstab = true;
        show_io_stat = true;
        net_auto = true;
        net_sync = true;
        base_10_bitrate = "Auto";
        show_battery = true;
        show_battery_watts = true;
        save_config_on_exit = true;
        nvml_measure_pcie_speeds = true;
        rsmi_measure_pcie_speeds = true;
        gpu_mirror_graph = true;
        shown_gpus = "nvidia amd intel";
      };
    };
  };
}
