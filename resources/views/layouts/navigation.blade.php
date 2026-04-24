<nav x-data="{ open: false, scrolled: false }"
     x-init="window.addEventListener('scroll', () => { scrolled = window.scrollY > 20 })"
     :class="{ 'scrolled': scrolled }"
     class="nav-gaming" id="navbar">

    <!-- Primary Navigation Menu -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16 items-center">

            <!-- Logo -->
            <div class="shrink-0 flex items-center">
                <a href="{{ route('home') }}" class="flex items-center gap-3 group">
                    <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-gaming-500 to-neon-purple flex items-center justify-center shadow-neon-purple transition-all duration-300 group-hover:shadow-neon-blue">
                        <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M21 6H3a1 1 0 00-1 1v10a1 1 0 001 1h18a1 1 0 001-1V7a1 1 0 00-1-1zM8 15a2 2 0 110-4 2 2 0 010 4zm4-2a1 1 0 110-2 1 1 0 010 2zm4 2a2 2 0 110-4 2 2 0 010 4z"/>
                        </svg>
                    </div>
                    <span class="text-xl font-bold text-neon hidden sm:block">JokiML</span>
                </a>
            </div>

            <!-- Desktop Navigation Links -->
            <div class="hidden md:flex items-center space-x-1">
                <a href="{{ route('home') }}"
                   class="px-4 py-2 rounded-lg text-sm font-medium text-gray-300 hover:text-white hover:bg-white/5 transition-all duration-200 {{ request()->routeIs('home') ? 'text-white bg-white/10' : '' }}">
                    Home
                </a>
                <a href="{{ route('home') }}#paket"
                   class="px-4 py-2 rounded-lg text-sm font-medium text-gray-300 hover:text-white hover:bg-white/5 transition-all duration-200">
                    Paket Joki
                </a>
                <a href="{{ route('home') }}#kalkulator"
                   class="px-4 py-2 rounded-lg text-sm font-medium text-gray-300 hover:text-white hover:bg-white/5 transition-all duration-200">
                    Kalkulator
                </a>
                <a href="{{ route('home') }}#testimoni"
                   class="px-4 py-2 rounded-lg text-sm font-medium text-gray-300 hover:text-white hover:bg-white/5 transition-all duration-200">
                    Testimoni
                </a>
                <a href="{{ route('home') }}#faq"
                   class="px-4 py-2 rounded-lg text-sm font-medium text-gray-300 hover:text-white hover:bg-white/5 transition-all duration-200">
                    FAQ
                </a>
            </div>

            <!-- Auth Buttons (Desktop) -->
            <div class="hidden md:flex items-center gap-3">
                @guest
                    <a href="{{ route('login') }}"
                       class="px-5 py-2 rounded-lg text-sm font-medium text-gray-300 hover:text-white border border-white/10 hover:border-gaming-500/50 hover:bg-gaming-500/10 transition-all duration-300">
                        Login
                    </a>
                    <a href="{{ route('register') }}"
                       class="btn-neon !px-5 !py-2 text-sm">
                        Register
                    </a>
                @endguest

                @auth
                    <x-dropdown align="right" width="48">
                        <x-slot name="trigger">
                            <button class="flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium text-gray-300 hover:text-white border border-white/10 hover:border-gaming-500/50 hover:bg-gaming-500/10 transition-all duration-300">
                                <div class="w-7 h-7 rounded-full bg-gradient-to-br from-gaming-500 to-neon-purple flex items-center justify-center text-xs font-bold text-white">
                                    {{ strtoupper(substr(Auth::user()->name, 0, 1)) }}
                                </div>
                                <span>{{ Auth::user()->name }}</span>
                                <svg class="w-4 h-4 opacity-50" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd"/>
                                </svg>
                            </button>
                        </x-slot>

                        <x-slot name="content">
                            <div class="bg-dark-800 border border-white/10 rounded-xl overflow-hidden shadow-2xl">
                                <x-dropdown-link :href="route('dashboard')" class="!text-gray-300 hover:!text-white hover:!bg-gaming-500/10">
                                    {{ __('Dashboard') }}
                                </x-dropdown-link>

                                <x-dropdown-link :href="route('profile.edit')" class="!text-gray-300 hover:!text-white hover:!bg-gaming-500/10">
                                    {{ __('Profile') }}
                                </x-dropdown-link>

                                <div class="border-t border-white/5"></div>

                                <form method="POST" action="{{ route('logout') }}">
                                    @csrf
                                    <x-dropdown-link :href="route('logout')"
                                        class="!text-red-400 hover:!text-red-300 hover:!bg-red-500/10"
                                        onclick="event.preventDefault(); this.closest('form').submit();">
                                        {{ __('Log Out') }}
                                    </x-dropdown-link>
                                </form>
                            </div>
                        </x-slot>
                    </x-dropdown>
                @endauth
            </div>

            <!-- Mobile Hamburger -->
            <div class="-me-2 flex items-center md:hidden">
                <button @click="open = !open"
                    class="inline-flex items-center justify-center p-2 rounded-lg text-gray-400 hover:text-white hover:bg-white/10 transition-all duration-200">
                    <svg class="h-6 w-6" stroke="currentColor" fill="none" viewBox="0 0 24 24">
                        <path :class="{'hidden': open, 'inline-flex': !open}" class="inline-flex"
                            stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M4 6h16M4 12h16M4 18h16"/>
                        <path :class="{'hidden': !open, 'inline-flex': open}" class="hidden"
                            stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>

        </div>
    </div>

    <!-- Mobile Responsive Menu -->
    <div :class="{'block': open, 'hidden': !open}" class="hidden md:hidden border-t border-white/5">
        <div class="px-4 py-3 space-y-1">
            <a href="{{ route('home') }}" class="block px-4 py-2.5 rounded-lg text-sm font-medium text-gray-300 hover:text-white hover:bg-white/5 transition-all">
                🏠 Home
            </a>
            <a href="{{ route('home') }}#paket" class="block px-4 py-2.5 rounded-lg text-sm font-medium text-gray-300 hover:text-white hover:bg-white/5 transition-all">
                📦 Paket Joki
            </a>
            <a href="{{ route('home') }}#kalkulator" class="block px-4 py-2.5 rounded-lg text-sm font-medium text-gray-300 hover:text-white hover:bg-white/5 transition-all">
                🧮 Kalkulator
            </a>
            <a href="{{ route('home') }}#testimoni" class="block px-4 py-2.5 rounded-lg text-sm font-medium text-gray-300 hover:text-white hover:bg-white/5 transition-all">
                ⭐ Testimoni
            </a>
            <a href="{{ route('home') }}#faq" class="block px-4 py-2.5 rounded-lg text-sm font-medium text-gray-300 hover:text-white hover:bg-white/5 transition-all">
                ❓ FAQ
            </a>
        </div>

        <div class="px-4 py-3 border-t border-white/5">
            @guest
                <div class="flex gap-3">
                    <a href="{{ route('login') }}" class="flex-1 text-center px-4 py-2.5 rounded-lg text-sm font-medium text-gray-300 border border-white/10 hover:border-gaming-500/50 transition-all">
                        Login
                    </a>
                    <a href="{{ route('register') }}" class="flex-1 text-center btn-neon !py-2.5 text-sm">
                        Register
                    </a>
                </div>
            @endguest

            @auth
                <div class="flex items-center gap-3 px-4 py-2 mb-2">
                    <div class="w-8 h-8 rounded-full bg-gradient-to-br from-gaming-500 to-neon-purple flex items-center justify-center text-sm font-bold text-white">
                        {{ strtoupper(substr(Auth::user()->name, 0, 1)) }}
                    </div>
                    <div>
                        <div class="text-sm font-medium text-white">{{ Auth::user()->name }}</div>
                        <div class="text-xs text-gray-400">{{ Auth::user()->email }}</div>
                    </div>
                </div>

                <a href="{{ route('dashboard') }}" class="block px-4 py-2.5 rounded-lg text-sm font-medium text-gray-300 hover:text-white hover:bg-white/5 transition-all">
                    📊 Dashboard
                </a>
                <a href="{{ route('profile.edit') }}" class="block px-4 py-2.5 rounded-lg text-sm font-medium text-gray-300 hover:text-white hover:bg-white/5 transition-all">
                    👤 Profile
                </a>

                <form method="POST" action="{{ route('logout') }}" class="mt-1">
                    @csrf
                    <button type="submit" class="w-full text-left px-4 py-2.5 rounded-lg text-sm font-medium text-red-400 hover:text-red-300 hover:bg-red-500/10 transition-all">
                        🚪 Log Out
                    </button>
                </form>
            @endauth
        </div>
    </div>
</nav>