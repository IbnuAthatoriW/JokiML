<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="dark">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="csrf-token" content="{{ csrf_token() }}">
        <meta name="description" content="Jasa Joki Mobile Legends profesional, aman, cepat, dan terpercaya. Naik rank dari Warrior sampai Mythic!">

        <title>{{ config('app.name', 'JokiML') }} - Jasa Joki Mobile Legends Profesional</title>

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

        <!-- Scripts -->
        @vite(['resources/css/app.css', 'resources/js/app.js'])
    </head>
    <body class="font-sans antialiased bg-dark-900 text-gray-200">
        <div class="min-h-screen bg-dark-900 bg-grid relative">
            @include('layouts.navigation')

            <!-- Page Heading -->
            @isset($header)
                <header class="pt-20">
                    <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                        {{ $header }}
                    </div>
                </header>
            @endisset

            <!-- Page Content -->
            <main class="@unless(isset($header)) pt-16 @endunless">
                {{ $slot }}
            </main>
        </div>
    </body>
</html>
