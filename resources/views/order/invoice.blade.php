<x-app-layout>
    <div class="py-12">
        <div class="max-w-3xl mx-auto sm:px-6 lg:px-8">

            @if(session('success'))
                <div class="mb-6 p-4 rounded-xl bg-green-500/20 border border-green-500/50 text-green-400 text-center font-semibold">
                    {{ session('success') }}
                </div>
            @endif

            <div class="glass-card p-8 relative overflow-hidden">
                {{-- Decorative --}}
                <div class="bg-orb bg-orb-blue w-48 h-48 -top-24 -right-24"></div>
                <div class="bg-orb bg-orb-purple w-32 h-32 -bottom-16 -left-16"></div>

                {{-- Header --}}
                <div class="text-center mb-8 relative">
                    <div class="w-20 h-20 mx-auto mb-4 rounded-full bg-green-500/20 border-2 border-green-500/50 flex items-center justify-center">
                        <svg class="w-10 h-10 text-green-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                        </svg>
                    </div>
                    <h2 class="text-2xl font-black text-white">Pembayaran <span class="text-neon">Berhasil!</span></h2>
                    <p class="text-gray-400 mt-2">Berikut adalah nota/bukti pemesanan Anda</p>
                </div>

                {{-- Invoice Card --}}
                <div class="bg-dark-800 rounded-xl border border-white/10 overflow-hidden mb-8">
                    {{-- Invoice Header --}}
                    <div class="bg-gradient-to-r from-gaming-500/20 to-neon-purple/20 border-b border-white/10 p-6">
                        <div class="flex items-center justify-between flex-wrap gap-4">
                            <div>
                                <h3 class="font-bold text-white text-lg">NOTA PEMESANAN</h3>
                                <p class="text-gaming-300 text-sm">JokiML Profesional</p>
                            </div>
                            <div class="text-right">
                                <p class="text-white font-bold text-lg">#INV-{{ str_pad($order->id, 5, '0', STR_PAD_LEFT) }}</p>
                                <p class="text-gray-400 text-xs">{{ $order->created_at->format('d M Y, H:i') }} WIB</p>
                            </div>
                        </div>
                    </div>

                    {{-- Invoice Body --}}
                    <div class="p-6 space-y-4">
                        {{-- Customer Info --}}
                        <div class="grid grid-cols-2 gap-4 pb-4 border-b border-white/5">
                            <div>
                                <p class="text-gray-500 text-xs uppercase tracking-wider mb-1">Nama Customer</p>
                                <p class="text-white font-semibold">{{ $order->customer_name }}</p>
                            </div>
                            <div>
                                <p class="text-gray-500 text-xs uppercase tracking-wider mb-1">No. WhatsApp</p>
                                <p class="text-white font-semibold">{{ $order->whatsapp }}</p>
                            </div>
                        </div>

                        {{-- Order Details --}}
                        <div class="pb-4 border-b border-white/5">
                            <p class="text-gray-500 text-xs uppercase tracking-wider mb-3">Detail Order</p>
                            <div class="space-y-2 text-sm">
                                <div class="flex justify-between">
                                    <span class="text-gray-400">Tipe Order</span>
                                    <span class="text-white font-semibold">{{ ucfirst($order->type) }}</span>
                                </div>
                                @if($order->type === 'paket')
                                <div class="flex justify-between">
                                    <span class="text-gray-400">Paket</span>
                                    <span class="text-white font-semibold">{{ $order->paket_name }}</span>
                                </div>
                                @else
                                <div class="flex justify-between">
                                    <span class="text-gray-400">Rank Asal</span>
                                    <span class="text-white font-semibold">{{ $order->from_rank }} ({{ $order->from_star }} ⭐)</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-400">Rank Tujuan</span>
                                    <span class="text-white font-semibold">{{ $order->to_rank }} ({{ $order->to_star }} ⭐)</span>
                                </div>
                                @endif
                                <div class="flex justify-between">
                                    <span class="text-gray-400">Game ID</span>
                                    <span class="text-white font-semibold">{{ $order->game_id }}</span>
                                </div>
                                @if($order->hero_request)
                                <div class="flex justify-between">
                                    <span class="text-gray-400">Request Hero</span>
                                    <span class="text-white font-semibold">{{ $order->hero_request }}</span>
                                </div>
                                @endif
                            </div>
                        </div>

                        {{-- Payment Info --}}
                        <div class="pb-4 border-b border-white/5">
                            <div class="flex justify-between items-center">
                                <div>
                                    <p class="text-gray-500 text-xs uppercase tracking-wider mb-1">Status Pembayaran</p>
                                    <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-green-500/20 text-green-400 rounded-full text-sm font-semibold">
                                        <span class="w-2 h-2 rounded-full bg-green-400 animate-pulse"></span>
                                        Sudah Dibayar ✅
                                    </span>
                                </div>
                                <div class="text-right">
                                    <p class="text-gray-500 text-xs uppercase tracking-wider mb-1">Status Order</p>
                                    <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-yellow-500/20 text-yellow-400 rounded-full text-sm font-semibold">
                                        {{ ucfirst($order->status) }}
                                    </span>
                                </div>
                            </div>
                        </div>

                        {{-- Total --}}
                        <div class="flex justify-between items-center pt-2">
                            <span class="text-gray-300 font-bold text-lg">Total Pembayaran</span>
                            <span class="text-neon text-2xl font-black">Rp {{ number_format($order->price, 0, ',', '.') }}</span>
                        </div>
                    </div>
                </div>

                {{-- Payment Proof Preview --}}
                @if($order->payment_proof)
                <div class="bg-dark-800 rounded-xl p-6 border border-white/10 mb-8">
                    <h3 class="font-bold text-white mb-4 flex items-center gap-2">
                        <svg class="w-5 h-5 text-gaming-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                        Bukti Pembayaran
                    </h3>
                    <div class="flex justify-center">
                        <img src="{{ asset('storage/' . $order->payment_proof) }}" alt="Bukti Pembayaran" class="max-w-sm w-full rounded-lg border border-white/10 shadow-lg">
                    </div>
                </div>
                @endif

                {{-- Actions --}}
                <div class="flex flex-col sm:flex-row gap-4 justify-center">
                    <a href="{{ route('dashboard') }}" class="btn-neon text-center text-sm">
                        🏠 Kembali ke Dashboard
                    </a>
                    <a href="https://wa.me/6285198181867?text=Halo,%20saya%20sudah%20melakukan%20pembayaran%20untuk%20order%20%23INV-{{ str_pad($order->id, 5, '0', STR_PAD_LEFT) }}" 
                       target="_blank"
                       class="px-8 py-3 rounded-xl font-semibold text-white border border-green-500/30 hover:border-green-500/60 hover:bg-green-500/10 transition-all duration-300 text-center text-sm">
                        💬 Konfirmasi via WhatsApp
                    </a>
                </div>

                {{-- Footer Note --}}
                <div class="mt-8 text-center text-xs text-gray-500">
                    <p>Order Anda akan segera diproses oleh tim kami.</p>
                    <p class="mt-1">Jika ada pertanyaan, silakan hubungi kami melalui WhatsApp.</p>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
