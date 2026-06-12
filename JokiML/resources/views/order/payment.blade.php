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

                {{-- Upload Bukti Pembayaran --}}
                <form method="POST" action="{{ route('order.confirm') }}" enctype="multipart/form-data" class="text-center" x-data="paymentUpload()">
                    @csrf
                    
                    <div class="bg-dark-800 rounded-xl p-6 border border-white/10 mb-8">
                        <h3 class="font-bold text-lg text-white mb-4">📤 Upload Bukti Pembayaran</h3>
                        <p class="text-sm text-gray-400 mb-4">Upload screenshot bukti transfer / pembayaran Anda</p>

                        {{-- Upload Area --}}
                        <label for="payment_proof" class="block cursor-pointer">
                            <div class="relative border-2 border-dashed rounded-xl p-8 transition-all duration-300"
                                 :class="hasFile ? 'border-green-500/50 bg-green-500/5' : 'border-white/20 hover:border-gaming-500/50 hover:bg-gaming-500/5'">
                                
                                {{-- No file state --}}
                                <div x-show="!hasFile" class="flex flex-col items-center gap-3">
                                    <div class="w-16 h-16 rounded-full bg-gaming-500/20 flex items-center justify-center">
                                        <svg class="w-8 h-8 text-gaming-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                        </svg>
                                    </div>
                                    <p class="text-gray-400 text-sm">Klik untuk memilih gambar bukti pembayaran</p>
                                    <p class="text-gray-500 text-xs">Format: JPG, PNG, WEBP (Maks. 5MB)</p>
                                </div>

                                {{-- File selected state --}}
                                <div x-show="hasFile" class="flex flex-col items-center gap-3">
                                    <div class="w-16 h-16 rounded-full bg-green-500/20 flex items-center justify-center">
                                        <svg class="w-8 h-8 text-green-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                                        </svg>
                                    </div>
                                    <p class="text-green-400 text-sm font-semibold" x-text="fileName"></p>
                                    <img :src="previewUrl" x-show="previewUrl" class="max-w-xs max-h-48 rounded-lg border border-white/10 mt-2 mx-auto" />
                                    <p class="text-gray-500 text-xs mt-1">Klik untuk ganti gambar</p>
                                </div>
                            </div>
                        </label>

                        <input type="file" name="payment_proof" id="payment_proof" accept="image/jpeg,image/jpg,image/png,image/webp"
                               class="hidden"
                               @change="handleFileSelect($event)">

                        @error('payment_proof')
                            <p class="text-red-400 text-sm mt-3">{{ $message }}</p>
                        @enderror
                    </div>

                    <button type="submit" 
                            class="w-full sm:w-auto px-12 py-4 text-lg font-semibold text-white rounded-xl overflow-hidden transition-all duration-300"
                            :class="hasFile ? 'bg-gradient-to-r from-indigo-500 to-purple-500 shadow-lg shadow-indigo-500/30 hover:-translate-y-0.5 cursor-pointer' : 'bg-gray-700 cursor-not-allowed opacity-50'"
                            :disabled="!hasFile">
                        <span x-show="!hasFile">⚠️ Upload Bukti Pembayaran Terlebih Dahulu</span>
                        <span x-show="hasFile">✅ Saya Sudah Bayar</span>
                    </button>
                    <p class="text-xs text-gray-500 mt-4">Dengan menekan tombol di atas, order akan diproses ke sistem admin.</p>
                </form>

            </div>
        </div>
    </div>

    <script>
    function paymentUpload() {
        return {
            hasFile: false,
            fileName: '',
            previewUrl: null,
            handleFileSelect(event) {
                const file = event.target.files[0];
                if (file) {
                    // Validate file type
                    const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
                    if (!validTypes.includes(file.type)) {
                        alert('Format file tidak valid! Gunakan JPG, PNG, atau WEBP.');
                        event.target.value = '';
                        return;
                    }
                    // Validate file size (5MB)
                    if (file.size > 5 * 1024 * 1024) {
                        alert('Ukuran file terlalu besar! Maksimal 5MB.');
                        event.target.value = '';
                        return;
                    }
                    this.hasFile = true;
                    this.fileName = file.name;
                    // Create preview
                    const reader = new FileReader();
                    reader.onload = (e) => {
                        this.previewUrl = e.target.result;
                    };
                    reader.readAsDataURL(file);
                } else {
                    this.hasFile = false;
                    this.fileName = '';
                    this.previewUrl = null;
                }
            }
        };
    }
    </script>
</x-app-layout>
