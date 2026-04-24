<x-app-layout>
    <div class="py-12">
        <div class="max-w-3xl mx-auto sm:px-6 lg:px-8">
            <div class="glass-card p-8">
                <div class="text-center mb-8">
                    <h2 class="text-2xl font-black text-white">Data <span class="text-neon">Akun</span></h2>
                    <p class="text-gray-400 mt-2">Lengkapi data akun Mobile Legends Anda untuk proses joki.</p>
                </div>

                <div class="bg-dark-800 rounded-xl p-6 border border-white/10 mb-8">
                    <h3 class="font-bold text-lg text-white mb-4 border-b border-white/10 pb-2">Ringkasan Pesanan</h3>
                    <div class="space-y-2 text-sm text-gray-300">
                        @if($orderData['type'] === 'paket')
                            <p><strong>Paket:</strong> {{ $orderData['paket_name'] }}</p>
                        @else
                            <p><strong>Dari:</strong> {{ $orderData['from_rank'] }} ({{ $orderData['from_star'] }}⭐)</p>
                            <p><strong>Tujuan:</strong> {{ $orderData['to_rank'] }} ({{ $orderData['to_star'] }}⭐)</p>
                        @endif
                        <p class="pt-2 border-t border-white/10 mt-2 text-xl font-bold text-neon">Total Harga: Rp {{ number_format($orderData['price'], 0, ',', '.') }}</p>
                    </div>
                </div>

                <form method="POST" action="{{ route('order.process') }}">
                    @csrf
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Nama Lengkap -->
                        <div>
                            <label class="block text-sm font-semibold text-gaming-300 mb-1" for="customer_name">Nama Lengkap *</label>
                            <input id="customer_name" name="customer_name" type="text" value="{{ old('customer_name', Auth::user()->name) }}" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500" required>
                            @error('customer_name') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
                        </div>

                        <!-- ID Game -->
                        <div>
                            <label class="block text-sm font-semibold text-gaming-300 mb-1" for="game_id">ID Game (Server) *</label>
                            <input id="game_id" name="game_id" type="text" placeholder="12345678 (1234)" value="{{ old('game_id') }}" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500" required>
                            @error('game_id') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
                        </div>

                        <!-- Akun Moonton (Email/VK/FB) -->
                        <div>
                            <label class="block text-sm font-semibold text-gaming-300 mb-1" for="moonton_account">Email / Akun Login *</label>
                            <input id="moonton_account" name="moonton_account" type="text" value="{{ old('moonton_account') }}" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500" required>
                            @error('moonton_account') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
                        </div>

                        <!-- Password Moonton -->
                        <div>
                            <label class="block text-sm font-semibold text-gaming-300 mb-1" for="moonton_password">Password Login *</label>
                            <input id="moonton_password" name="moonton_password" type="text" value="{{ old('moonton_password') }}" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500" required>
                            @error('moonton_password') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
                        </div>

                        <!-- Request Hero -->
                        <div class="md:col-span-2">
                            <label class="block text-sm font-semibold text-gaming-300 mb-1" for="hero_request">Request 3 Hero (Opsional)</label>
                            <input id="hero_request" name="hero_request" type="text" placeholder="Gusion, Lancelot, Fanny" value="{{ old('hero_request') }}" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500">
                            @error('hero_request') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
                        </div>

                        <!-- No WhatsApp -->
                        <div class="md:col-span-2">
                            <label class="block text-sm font-semibold text-gaming-300 mb-1" for="whatsapp">No. WhatsApp *</label>
                            <input id="whatsapp" name="whatsapp" type="text" placeholder="081234567890" value="{{ old('whatsapp') }}" class="w-full rounded-xl bg-dark-700 border border-white/10 text-white px-4 py-3 focus:border-gaming-500 focus:ring-gaming-500" required>
                            <p class="text-xs text-gray-500 mt-1">Kami akan menghubungi Anda untuk konfirmasi proses login akun.</p>
                            @error('whatsapp') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
                        </div>
                    </div>

                    <div class="mt-8 text-center">
                        <button type="submit" class="btn-neon w-full sm:w-auto px-12 py-4 text-lg">
                            Lanjut Pembayaran
                        </button>
                    </div>
                </form>

            </div>
        </div>
    </div>
</x-app-layout>
