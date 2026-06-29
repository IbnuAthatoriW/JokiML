<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="dark">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        <title>{{ config('app.name', 'JokiML') }}</title>

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.bunny.net">
        <link href="https://fonts.bunny.net/css?family=inter:400,500,600,700,800,900&display=swap" rel="stylesheet" />

        <!-- Scripts -->
        @vite(['resources/css/app.css', 'resources/js/app.js'])
    </head>
    <body class="font-inter antialiased bg-dark-900 text-gray-200 overflow-x-hidden min-h-screen relative selection:bg-neon-purple selection:text-white">
        <!-- Background Grid & Orbs -->
        <div class="fixed inset-0 z-0 pointer-events-none">
            <div class="absolute inset-0 bg-grid opacity-20"></div>
            <div class="bg-orb bg-orb-purple w-[30rem] h-[30rem] top-0 left-0 opacity-40"></div>
            <div class="bg-orb bg-orb-blue w-[40rem] h-[40rem] bottom-0 right-0 opacity-40"></div>
            <div class="absolute inset-0 bg-dark-900/40 backdrop-blur-[100px]"></div>
        </div>

        <div class="relative z-10 min-h-screen flex flex-col sm:justify-center items-center pt-6 sm:pt-0">
            <div>
                <a href="/" class="flex items-center gap-3 group">
                    <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-gaming-500 to-neon-purple flex items-center justify-center shadow-[0_0_20px_rgba(99,102,241,0.5)] group-hover:shadow-[0_0_30px_rgba(168,85,247,0.6)] transition-all duration-300">
                        <span class="text-white font-black text-xl tracking-tighter">🎮</span>
                    </div>
                    <span class="text-2xl font-black text-white tracking-tight group-hover:text-transparent group-hover:bg-clip-text group-hover:bg-gradient-to-r group-hover:from-neon-blue group-hover:to-neon-purple transition-all duration-300">Joki<span class="text-neon">ML</span></span>
                </a>
            </div>

            <div class="w-full sm:max-w-md mt-8 px-8 py-8 glass-card">
                {{ $slot }}
            </div>
        </div>
    </body>
</html>
