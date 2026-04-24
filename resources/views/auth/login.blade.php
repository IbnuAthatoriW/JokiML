<x-guest-layout>
    <div class="mb-6 text-center">
        <h2 class="text-2xl font-bold text-white">Welcome Back</h2>
        <p class="text-gray-400 text-sm mt-1">Login to your JokiML account</p>
    </div>

    <!-- Session Status -->
    <x-auth-session-status class="mb-4" :status="session('status')" />

    @if ($errors->any())
        <div class="mb-4 p-4 rounded-xl bg-red-500/20 border border-red-500/50 text-red-400 text-sm text-center">
            Email atau password yang Anda masukkan salah.
        </div>
    @endif

    <form method="POST" action="{{ route('login') }}">
        @csrf

        <!-- Email Address -->
        <div>
            <label class="block text-sm font-semibold text-gaming-300 mb-1" for="email">{{ __('Email') }}</label>
            <input id="email" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500 transition-all" type="email" name="email" value="{{ old('email') }}" required autofocus autocomplete="username" />
            <x-input-error :messages="$errors->get('email')" class="mt-2 text-red-400" />
        </div>

        <!-- Password -->
        <div class="mt-4">
            <label class="block text-sm font-semibold text-gaming-300 mb-1" for="password">{{ __('Password') }}</label>
            <input id="password" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500 transition-all" type="password" name="password" required autocomplete="current-password" />
            <x-input-error :messages="$errors->get('password')" class="mt-2 text-red-400" />
        </div>

        <!-- Remember Me -->
        <div class="block mt-4">
            <label for="remember_me" class="inline-flex items-center">
                <input id="remember_me" type="checkbox" class="rounded bg-dark-700 border-white/10 text-gaming-500 shadow-sm focus:ring-gaming-500 focus:ring-offset-dark-900" name="remember">
                <span class="ms-2 text-sm text-gray-400">{{ __('Remember me') }}</span>
            </label>
        </div>

        <div class="flex items-center justify-between mt-6">
            @if (Route::has('password.request'))
                <a class="text-sm text-gaming-400 hover:text-neon transition-colors" href="{{ route('password.request') }}">
                    {{ __('Forgot your password?') }}
                </a>
            @endif

            <button class="btn-neon text-sm px-6 py-2">
                {{ __('Log in') }}
            </button>
        </div>
    </form>
</x-guest-layout>
