<x-app-layout>
    <div class="py-12">
        <div class="max-w-3xl mx-auto sm:px-6 lg:px-8">
            <div class="glass-card p-8">
                <div class="text-center mb-8">
                    <h2 class="text-2xl font-black text-white">Pembayaran <span class="text-neon">Order</span></h2>
                    <p class="text-gray-400 mt-2">Silakan selesaikan pembayaran untuk order Anda.</p>
                </div>

                <div class="bg-dark-800 rounded-xl p-6 border border-white/10 mb-8">
                    <h3 class="font-bold text-lg text-white mb-4 border-b border-white/10 pb-2">Detail Order</h3>
                    
                    <div class="space-y-3 text-sm">
                        <div class="flex justify-between">
                            <span class="text-gray-400">Tipe Order</span>
                            <span class="text-white font-semibold">{{ ucfirst($orderData['type']) }}</span>
                        </div>
                        
                        @if($orderData['type'] === 'paket')
                        <div class="flex justify-between">
                            <span class="text-gray-400">Paket</span>
                            <span class="text-white font-semibold">{{ $orderData['paket_name'] }}</span>
                        </div>
                        @else
                        <div class="flex justify-between">
                            <span class="text-gray-400">Rank Asal</span>
                            <span class="text-white font-semibold">{{ $orderData['from_rank'] }} ({{ $orderData['from_star'] }} Bintang)</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-400">Rank Tujuan</span>
                            <span class="text-white font-semibold">{{ $orderData['to_rank'] }} ({{ $orderData['to_star'] }} Bintang)</span>
                        </div>
                        @endif

                        <div class="flex justify-between pt-3 border-t border-white/10 mt-3">
                            <span class="text-gray-300 font-bold">Total Pembayaran</span>
                            <span class="text-neon text-xl font-black">Rp {{ number_format($orderData['price'], 0, ',', '.') }}</span>
                        </div>
                    </div>
                </div>

                <div class="bg-dark-800 rounded-xl p-6 border border-gaming-500/30 mb-8 text-center">
                    <h3 class="font-bold text-lg text-white mb-4">Scan QRIS</h3>
                    <p class="text-sm text-gray-400 mb-6">Gunakan aplikasi e-Wallet atau m-Banking Anda (Gopay, OVO, Dana, BCA, dll)</p>
                    
                    <div class="w-64 mx-auto bg-white rounded-xl p-2 flex items-center justify-center border-4 border-gaming-500 overflow-hidden">
                        <img src="{{ asset('img/qris.jpeg') }}" alt="QRIS Payment" class="w-full h-auto object-cover">
                    </div>
                    
                    <div class="mt-4">
                        <span class="inline-block bg-gaming-500 text-white text-xs px-3 py-1 rounded-full font-bold">a.n JOKI ML PROFESIONAL</span>
                    </div>
                </div>

                <form method="POST" action="{{ route('order.confirm') }}" class="text-center">
                    @csrf
                    <button type="submit" class="btn-neon w-full sm:w-auto px-12 py-4 text-lg">
                        Saya Sudah Bayar
                    </button>
                    <p class="text-xs text-gray-500 mt-4">Dengan menekan tombol di atas, order akan diproses ke sistem admin.</p>
                </form>

            </div>
        </div>
    </div>
</x-app-layout>
