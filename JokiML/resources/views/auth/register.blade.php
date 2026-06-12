<x-guest-layout>
    <div class="mb-6 text-center">
        <h2 class="text-2xl font-bold text-white">Create an Account</h2>
        <p class="text-gray-400 text-sm mt-1">Join JokiML for the best service</p>
    </div>

    <form method="POST" action="{{ route('register') }}">
        @csrf

        <!-- Name -->
        <div>
            <label class="block text-sm font-semibold text-gaming-300 mb-1" for="name">{{ __('Name') }}</label>
            <input id="name" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500 transition-all" type="text" name="name" value="{{ old('name') }}" required autofocus autocomplete="name" />
            <x-input-error :messages="$errors->get('name')" class="mt-2 text-red-400" />
        </div>

        <!-- Email Address -->
        <div class="mt-4">
            <label class="block text-sm font-semibold text-gaming-300 mb-1" for="email">{{ __('Email') }}</label>
            <input id="email" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500 transition-all" type="email" name="email" value="{{ old('email') }}" required autocomplete="username" />
            <x-input-error :messages="$errors->get('email')" class="mt-2 text-red-400" />
        </div>

        <!-- Password -->
        <div class="mt-4">
            <label class="block text-sm font-semibold text-gaming-300 mb-1" for="password">{{ __('Password') }}</label>
            <input id="password" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500 transition-all" type="password" name="password" required autocomplete="new-password" />
            <x-input-error :messages="$errors->get('password')" class="mt-2 text-red-400" />
        </div>

        <!-- Confirm Password -->
        <div class="mt-4">
            <label class="block text-sm font-semibold text-gaming-300 mb-1" for="password_confirmation">{{ __('Confirm Password') }}</label>
            <input id="password_confirmation" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500 transition-all" type="password" name="password_confirmation" required autocomplete="new-password" />
            <x-input-error :messages="$errors->get('password_confirmation')" class="mt-2 text-red-400" />
        </div>

        <!-- Authentifikasi (Admin) -->
        <div class="mt-4">
            <label class="block text-sm font-semibold text-gaming-300 mb-1" for="authentifikasi">Kode Authentifikasi <span class="text-xs text-gray-500 font-normal">(Opsional)</span></label>
            <input id="authentifikasi" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500 transition-all" type="text" name="authentifikasi" value="{{ old('authentifikasi') }}" placeholder="Isi hanya jika admin" />
            <x-input-error :messages="$errors->get('authentifikasi')" class="mt-2 text-red-400" />
        </div>

        <div class="flex items-center justify-between mt-6">
            <a class="text-sm text-gaming-400 hover:text-neon transition-colors" href="{{ route('login') }}">
                {{ __('Already registered?') }}
            </a>

            <button class="btn-neon text-sm px-6 py-2">
                {{ __('Register') }}
            </button>
        </div>
    </form>
</x-guest-layout>
